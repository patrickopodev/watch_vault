import '../../domain/entities/sport_event.dart';
import '../../domain/entities/standing.dart';
import '../sources/remote/sports_api.dart';
import '../sources/local/hive_storage.dart';

class SportsRepository {
  final SportsApi _api;

  static const List<String> _globalPriority = [
    'FIFA World Cup',
    'World Cup',
    'UEFA Champions League',
    'UEFA Europa League',
    'English Premier League',
    'Premier League',
    'La Liga',
    'Bundesliga',
    'Serie A',
    'Ligue 1',
  ];

  SportsRepository(this._api);

  int _priorityIndex(String? league) {
    if (league == null) return _globalPriority.length;
    for (var i = 0; i < _globalPriority.length; i++) {
      if (league.contains(_globalPriority[i])) return i;
    }
    return _globalPriority.length;
  }

  List<SportEvent> _sortGlobalPriority(List<SportEvent> events) {
    final sorted = List<SportEvent>.from(events);
    sorted.sort((a, b) {
      final aIsWorldCup = a.league?.contains('World Cup') == true || a.league?.contains('FIFA') == true;
      final bIsWorldCup = b.league?.contains('World Cup') == true || b.league?.contains('FIFA') == true;
      if (aIsWorldCup && !bIsWorldCup) return -1;
      if (!aIsWorldCup && bIsWorldCup) return 1;
      final ap = _priorityIndex(a.league);
      final bp = _priorityIndex(b.league);
      if (ap != bp) return ap - bp;
      if (a.isLive && !b.isLive) return -1;
      if (!a.isLive && b.isLive) return 1;
      return 0;
    });
    return sorted;
  }

  Future<List<SportEvent>> getLiveScores({String? sport, String? league}) async {
    try {
      final models = await _api.getLiveScores(sport: sport, league: league);
      if (models.isNotEmpty) {
        await HiveStorage.cacheLiveScores(models);
        return _sortGlobalPriority(models.map((m) => m.toEntity()).toList());
      }
    } catch (_) {}

    final cached = HiveStorage.getCachedLiveScores();
    if (sport != null) {
      return _sortGlobalPriority(cached.where((m) => m.sport == sport).map((m) => m.toEntity()).toList());
    }
    return _sortGlobalPriority(cached.map((m) => m.toEntity()).toList());
  }

  Future<List<SportEvent>> getUpcomingMatches({String? sport, String? league}) async {
    try {
      final models = await _api.getUpcomingMatches(sport: sport, league: league);
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      return [];
    }
  }

  Future<SportEvent?> getMatchById(String matchId) async {
    final scores = await getLiveScores();
    try {
      return scores.firstWhere((s) => s.matchId == matchId);
    } catch (_) {
      return null;
    }
  }

  Future<List<Standing>> getStandings({String? league}) async {
    try {
      return await _api.getStandings(league: league);
    } catch (_) {
      return _mockStandings();
    }
  }

  Future<void> setFavoriteTeams(List<String> teams) async {
    await HiveStorage.setPreference('favorite_teams', teams);
  }

  List<String> getFavoriteTeams() {
    final data = HiveStorage.getPreference('favorite_teams');
    if (data is List) return data.cast<String>();
    return [];
  }

  List<Standing> _mockStandings() {
    return [
      Standing(position: 1, teamName: 'Manchester City', played: 28, won: 20, drawn: 5, lost: 3, goalsFor: 62, goalsAgainst: 17, goalDifference: 45, points: 65, league: 'Premier League'),
      Standing(position: 2, teamName: 'Liverpool', played: 28, won: 19, drawn: 7, lost: 2, goalsFor: 58, goalsAgainst: 20, goalDifference: 38, points: 64, league: 'Premier League'),
      Standing(position: 3, teamName: 'Arsenal', played: 28, won: 18, drawn: 6, lost: 4, goalsFor: 52, goalsAgainst: 20, goalDifference: 32, points: 60, league: 'Premier League'),
      Standing(position: 4, teamName: 'Aston Villa', played: 28, won: 17, drawn: 5, lost: 6, goalsFor: 48, goalsAgainst: 28, goalDifference: 20, points: 56, league: 'Premier League'),
      Standing(position: 5, teamName: 'Tottenham', played: 28, won: 16, drawn: 5, lost: 7, goalsFor: 45, goalsAgainst: 30, goalDifference: 15, points: 53, league: 'Premier League'),
      Standing(position: 6, teamName: 'Manchester United', played: 28, won: 14, drawn: 8, lost: 6, goalsFor: 38, goalsAgainst: 28, goalDifference: 10, points: 50, league: 'Premier League'),
      Standing(position: 7, teamName: 'West Ham', played: 28, won: 12, drawn: 8, lost: 8, goalsFor: 35, goalsAgainst: 33, goalDifference: 2, points: 44, league: 'Premier League'),
      Standing(position: 8, teamName: 'Chelsea', played: 28, won: 11, drawn: 7, lost: 10, goalsFor: 30, goalsAgainst: 33, goalDifference: -3, points: 40, league: 'Premier League'),
    ];
  }
}
