/**
 * StreamVault Caching Worker
 *
 * Sits between the Flutter app and external APIs.
 * Caches all responses in Cloudflare's global CDN.
 * 1,000 users asking for the same data = 1 real API call.
 */

const CACHE_TTL = {
  SPORTS: 60,          // live scores: 60s
  STANDINGS: 300,      // standings: 5 min
  MATCHES: 120,        // match details: 2 min
  METADATA: 86400,     // logos, team info: 24h
};

async function handleRequest(request, env) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cacheKey = new Request(url.toString(), request);
  const cache = caches.default;

  // 1. Check cache first
  const cached = await cache.match(cacheKey);
  if (cached) {
    return cached;
  }

  let response;
  const origin = url.searchParams.get("origin") || "thesportsdb";

  try {
    switch (origin) {
      case "thesportsdb": {
        const endpoint = url.searchParams.get("endpoint") || "lookup";
        const query = url.searchParams.get("q") || "";
        const apiKey = env.SPORTSDB_API_KEY || "3";
        const apiUrl = `https://www.thesportsdb.com/api/v1/json/${apiKey}/${endpoint}.php${query ? `?${query}` : ""}`;

        const apiResp = await fetch(apiUrl, {
          headers: { "User-Agent": "StreamVault/1.0" },
        });
        const data = await apiResp.json();

        response = new Response(JSON.stringify(data), {
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Cache-Control": `public, s-maxage=${CACHE_TTL.SPORTS}`,
          },
        });
        break;
      }

      case "supabase": {
        const table = url.searchParams.get("table") || "live_scores";
        const sport = url.searchParams.get("sport");
        const league = url.searchParams.get("league");
        const status = url.searchParams.get("status");
        const limit = url.searchParams.get("limit");
        const order = url.searchParams.get("order");
        const supabaseUrl = env.SUPABASE_URL;
        if (!supabaseUrl) {
          return new Response(JSON.stringify({ error: "Supabase not configured" }), { status: 500 });
        }
        const supabaseKey = env.SUPABASE_SERVICE_KEY || request.headers.get("X-Supabase-Key") || "";

        let query = `${supabaseUrl}/rest/v1/${table}?select=*`;
        if (sport) query += `&sport=eq.${sport}`;
        if (league) query += `&league=eq.${league}`;
        if (status) query += `&status=eq.${status}`;
        if (order) query += `&order=${order}`;
        if (limit) query += `&limit=${limit}`;

        const apiResp = await fetch(query, {
          headers: {
            apikey: supabaseKey,
            Authorization: `Bearer ${supabaseKey}`,
          },
        });
        const data = await apiResp.json();

        response = new Response(JSON.stringify(data), {
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Cache-Control": `public, s-maxage=${CACHE_TTL.SPORTS}`,
          },
        });
        break;
      }

      case "tmdb": {
        const endpoint = url.searchParams.get("endpoint") || "movie/popular";
        const apiKey = url.searchParams.get("api_key") || "";
        const apiUrl = `https://api.themoviedb.org/3/${endpoint}?api_key=${apiKey}&${url.searchParams.toString()}`;

        const apiResp = await fetch(apiUrl);
        const data = await apiResp.json();

        response = new Response(JSON.stringify(data), {
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Cache-Control": `public, s-maxage=${CACHE_TTL.METADATA}`,
          },
        });
        break;
      }

      default:
        response = new Response(JSON.stringify({ error: "Unknown origin" }), { status: 400 });
    }
  } catch (err) {
    response = new Response(JSON.stringify({ error: err.message }), { status: 502 });
  }

  // 2. Store in cache
  if (response.status === 200) {
    const headers = new Headers(response.headers);
    headers.set("CF-Cache-Status", "HIT");
    await cache.put(cacheKey, response.clone());
  }

  return response;
}

export default {
  fetch(request, env, ctx) { return handleRequest(request, env); },
};
