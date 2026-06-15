import '../../domain/entities/sport_event.dart';
import '../sources/remote/sports_api.dart';
import '../sources/local/hive_storage.dart';
class SportsRepository {
  final SportsApi _api;

  static const List<String> _GLOBAL_PRIORITY = [
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
    if (league == null) return _GLOBAL_PRIORITY.length;
    for (var i = 0; i < _GLOBAL_PRIORITY.length; i++) {
      if (league.contains(_GLOBAL_PRIORITY[i])) return i;
    }
    return _GLOBAL_PRIORITY.length;
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
}
