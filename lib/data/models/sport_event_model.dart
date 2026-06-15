import '../../domain/entities/sport_event.dart';

class SportEventModel {
  final String matchId;
  final String sport;
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String minute;
  final String status;
  final String? league;
  final String? leagueLogo;
  final String? homeLogo;
  final String? awayLogo;
  final String? venue;
  final DateTime? scrapedAt;

  const SportEventModel({
    required this.matchId,
    this.sport = 'football',
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    this.minute = 'scheduled',
    this.status = 'scheduled',
    this.league,
    this.leagueLogo,
    this.homeLogo,
    this.awayLogo,
    this.venue,
    this.scrapedAt,
  });

  factory SportEventModel.fromJson(Map<String, dynamic> json) {
    return SportEventModel(
      matchId: json['match_id'] as String,
      sport: json['sport'] as String? ?? 'football',
      homeTeam: json['home_team'] as String,
      awayTeam: json['away_team'] as String,
      homeScore: json['home_score'] as int?,
      awayScore: json['away_score'] as int?,
      minute: json['minute'] as String? ?? 'scheduled',
      status: json['status'] as String? ?? 'scheduled',
      league: json['league'] as String?,
      leagueLogo: json['league_logo'] as String?,
      homeLogo: json['home_logo'] as String?,
      awayLogo: json['away_logo'] as String?,
      venue: json['venue'] as String?,
      scrapedAt: json['scraped_at'] != null ? DateTime.tryParse(json['scraped_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match_id': matchId,
      'sport': sport,
      'home_team': homeTeam,
      'away_team': awayTeam,
      'home_score': homeScore,
      'away_score': awayScore,
      'minute': minute,
      'status': status,
      'league': league,
      'league_logo': leagueLogo,
      'home_logo': homeLogo,
      'away_logo': awayLogo,
      'venue': venue,
      'scraped_at': scrapedAt?.toIso8601String(),
    };
  }

  SportEvent toEntity() {
    return SportEvent(
      matchId: matchId,
      sport: sport,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      homeScore: homeScore,
      awayScore: awayScore,
      minute: minute,
      status: status,
      league: league,
      leagueLogo: leagueLogo,
      homeLogo: homeLogo,
      awayLogo: awayLogo,
      venue: venue,
      scrapedAt: scrapedAt,
    );
  }

  factory SportEventModel.fromEntity(SportEvent entity) {
    return SportEventModel(
      matchId: entity.matchId,
      sport: entity.sport,
      homeTeam: entity.homeTeam,
      awayTeam: entity.awayTeam,
      homeScore: entity.homeScore,
      awayScore: entity.awayScore,
      minute: entity.minute,
      status: entity.status,
      league: entity.league,
      leagueLogo: entity.leagueLogo,
      homeLogo: entity.homeLogo,
      awayLogo: entity.awayLogo,
      venue: entity.venue,
      scrapedAt: entity.scrapedAt,
    );
  }
}
