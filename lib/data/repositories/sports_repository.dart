import '../../domain/entities/sport_event.dart';
import '../sources/remote/sports_api.dart';
import '../sources/local/hive_storage.dart';
import '../models/sport_event_model.dart';

class SportsRepository {
  final SportsApi _api;

  SportsRepository(this._api);

  Future<List<SportEvent>> getLiveScores({String? sport, String? league}) async {
    try {
      final models = await _api.getLiveScores(sport: sport, league: league);
      if (models.isNotEmpty) {
        await HiveStorage.cacheLiveScores(models);
        return models.map((m) => m.toEntity()).toList();
      }
    } catch (_) {}

    final cached = HiveStorage.getCachedLiveScores();
    if (sport != null) {
      return cached.where((m) => m.sport == sport).map((m) => m.toEntity()).toList();
    }
    return cached.map((m) => m.toEntity()).toList();
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
