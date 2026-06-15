import json
import os
import re
import time
from datetime import datetime, timezone

import requests
from bs4 import BeautifulSoup

FLASHSCORE_MOBILE = "https://m.flashscore.com"
SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_KEY", "")

SPORTS_CONFIG = [
    {"sport": "football", "path": "/"},
    {"sport": "basketball", "path": "/basketball/"},
    {"sport": "tennis", "path": "/tennis/"},
    {"sport": "rugby", "path": "/rugby-union/"},
    {"sport": "cricket", "path": "/cricket/"},
    {"sport": "mma", "path": "/mma/"},
]

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36"
}

LIVE_STATUSES = {"live", "1st-half", "2nd-half", "1st-set", "2nd-set", "3rd-set",
                 "4th-set", "5th-set", "1st-quarter", "2nd-quarter", "3rd-quarter",
                 "4th-quarter", "overtime", "half-time", "interrupted"}


def normalize_league_name(raw: str) -> str:
    return raw.replace("\u00a0", " ").strip()


def parse_matches(html: str, sport: str) -> list[dict]:
    soup = BeautifulSoup(html, "lxml")
    score_data = soup.find(id="score-data")
    if not score_data:
        return []

    matches = []
    current_league = None

    for child in score_data.children:
        if child.name == "h4":
            league_text = child.get_text(strip=True)
            league_text = re.sub(r'\s*Standings\s*$', '', league_text)
            current_league = normalize_league_name(league_text)

        elif child.name == "span":
            time_el = child
            time_text = time_el.get_text(strip=True)
            status_tag = time_el.get("class", [])
            is_live = "live" in status_tag

            # Determine status
            if is_live:
                status = "live"
            elif any(w in time_text for w in ("Postponed", "Cancelled", "Suspended")):
                status = time_text.strip().lower()
            else:
                status = "scheduled"

            # After the span, collect all following siblings to build the match entry
            team_parts = []
            score_text = None
            match_id = None
            is_finished = False

            node = time_el.next_sibling
            while node:
                if node.name == "a":
                    score_text = node.get_text(strip=True)
                    match_id_match = re.search(r"/match/([^/]+)/", node.get("href", ""))
                    if match_id_match:
                        match_id = match_id_match.group(1)
                    classes = node.get("class", [])
                    if "fin" in classes:
                        is_finished = True
                        if status == "scheduled":
                            status = "finished"
                    elif "live" in classes:
                        status = "live"
                    break
                elif node.name == "br":
                    break
                elif node.name == "img":
                    node = node.next_sibling
                    continue
                elif isinstance(node, str):
                    text = node.strip()
                    if text:
                        team_parts.append(text)
                node = node.next_sibling

            team_text = " ".join(team_parts)

            # Split team names
            home_team = None
            away_team = None
            if " - " in team_text:
                parts = team_text.split(" - ", 1)
                home_team = parts[0].strip()
                away_team = parts[1].strip()

            if not home_team or not away_team:
                continue

            if not match_id:
                match_id = str(abs(hash(home_team + away_team + sport + status)))

            # Parse score
            home_score = None
            away_score = None
            if score_text and score_text not in ("vs", "?", "-", ""):
                if sport == "cricket" and "/" in score_text:
                    score_parts = score_text.split("/")
                    if len(score_parts) >= 2:
                        home_score = f"{score_parts[0]}/{score_parts[1]}"
                        if len(score_parts) > 2:
                            away_score = f"{score_parts[2]}/{score_parts[3]}"
                elif "-" in score_text:
                    score_parts = score_text.split("-", 1)
                    home_score = score_parts[0].strip()
                    away_score = score_parts[1].strip()

            # Determine minute display
            minute = None
            if is_live:
                minute_text = time_text.strip()
                if minute_text and minute_text not in ("live", "Live"):
                    minute = minute_text

            matches.append({
                "match_id": match_id,
                "sport": sport,
                "home_team": home_team,
                "away_team": away_team,
                "home_score": home_score,
                "away_score": away_score,
                "minute": minute,
                "status": "finished" if is_finished else status,
                "league": current_league,
                "scraped_at": datetime.now(timezone.utc).isoformat(),
            })

    return matches


def push_to_supabase(matches: list[dict]) -> int:
    if not SUPABASE_URL or not SUPABASE_KEY:
        return 0

    headers = {
        "apikey": SUPABASE_KEY,
        "Authorization": f"Bearer {SUPABASE_KEY}",
        "Content-Type": "application/json",
        "Prefer": "resolution=merge-duplicates",
    }

    pushed = 0
    for match in matches:
        resp = requests.post(
            f"{SUPABASE_URL}/rest/v1/live_scores",
            json=match,
            headers=headers,
        )
        if resp.ok or resp.status_code == 409:
            pushed += 1
        else:
            print(f"  failed ({resp.status_code}): {match['match_id']} ({match['sport']})")

    return pushed


if __name__ == "__main__":
    all_matches = []
    now = datetime.now(timezone.utc).isoformat()
    print(f"[{now}] Starting multi-sport scrape (mobile FlashScore)")

    scrape_sports_env = os.getenv("SCRAPE_SPORTS", "")
    scrape_sports = [s.strip().lower() for s in scrape_sports_env.split(",") if s.strip()] if scrape_sports_env else []

    for cfg in SPORTS_CONFIG:
        sport = cfg["sport"]
        if scrape_sports and sport not in scrape_sports:
            continue

        url = f"{FLASHSCORE_MOBILE}{cfg['path']}"
        print(f"  Fetching {sport} ({url})...")
        try:
            resp = requests.get(url, headers=HEADERS, timeout=30)
            resp.raise_for_status()
            matches = parse_matches(resp.text, sport)
            print(f"    parsed {len(matches)} {sport} matches")
            live_count = sum(1 for m in matches if m["status"] == "live")
            if live_count:
                print(f"    ({live_count} live)")
            all_matches.extend(matches)
            time.sleep(1)
        except Exception as e:
            print(f"    error scraping {sport}: {e}")

    print(f"  total: {len(all_matches)} matches across all sports")

    if all_matches:
        pushed = push_to_supabase(all_matches)
        print(f"  pushed {pushed} to Supabase")

    output_path = os.path.join(os.path.dirname(__file__), "live_scores_output.json")
    with open(output_path, "w") as f:
        json.dump(all_matches, f, indent=2)
    print(f"  wrote {output_path}")
