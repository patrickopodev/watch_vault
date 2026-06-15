import 'package:flutter/material.dart';

class SportEvent {
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

  const SportEvent({
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

  bool get isLive => status == 'live';
  bool get isFinished => status == 'finished' || minute == 'FT';
  bool get isUpcoming => status == 'scheduled' && !isLive && !isFinished;

  IconData get sportIcon {
    switch (sport) {
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      case 'rugby':
        return Icons.sports_rugby;
      case 'cricket':
        return Icons.sports_cricket;
      case 'mma':
      case 'boxing':
        return Icons.sports_mma;
      default:
        return Icons.sports_soccer;
    }
  }

  String get sportLabel {
    switch (sport) {
      case 'basketball':
        return 'Basketball';
      case 'tennis':
        return 'Tennis';
      case 'rugby':
        return 'Rugby';
      case 'cricket':
        return 'Cricket';
      case 'mma':
        return 'MMA';
      case 'boxing':
        return 'Boxing';
      default:
        return 'Football';
    }
  }

  SportEvent copyWith({
    String? matchId,
    String? sport,
    String? homeTeam,
    String? awayTeam,
    int? homeScore,
    int? awayScore,
    String? minute,
    String? status,
    String? league,
    String? leagueLogo,
    String? homeLogo,
    String? awayLogo,
    String? venue,
    DateTime? scrapedAt,
  }) {
    return SportEvent(
      matchId: matchId ?? this.matchId,
      sport: sport ?? this.sport,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      minute: minute ?? this.minute,
      status: status ?? this.status,
      league: league ?? this.league,
      leagueLogo: leagueLogo ?? this.leagueLogo,
      homeLogo: homeLogo ?? this.homeLogo,
      awayLogo: awayLogo ?? this.awayLogo,
      venue: venue ?? this.venue,
      scrapedAt: scrapedAt ?? this.scrapedAt,
    );
  }
}
