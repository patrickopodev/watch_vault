import 'package:hive_flutter/hive_flutter.dart';
import '../../models/sport_event_model.dart';

class HiveStorage {
  static const String _sportsBox = 'sports_cache';
  static const String _moviesBox = 'movies_cache';
  static const String _prefsBox = 'preferences';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_sportsBox);
    await Hive.openBox(_moviesBox);
    await Hive.openBox(_prefsBox);
  }

  // Sports cache
  static Future<void> cacheLiveScores(List<SportEventModel> scores) async {
    final box = Hive.box(_sportsBox);
    final jsonList = scores.map((s) => s.toJson()).toList();
    await box.put('live_scores', jsonList);
    await box.put('last_updated', DateTime.now().toIso8601String());
  }

  static List<SportEventModel> getCachedLiveScores() {
    final box = Hive.box(_sportsBox);
    final data = box.get('live_scores') as List<dynamic>?;
    if (data == null) return [];
    return data
        .map((e) => SportEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static DateTime? getLastUpdated() {
    final box = Hive.box(_sportsBox);
    final timestamp = box.get('last_updated') as String?;
    if (timestamp == null) return null;
    return DateTime.tryParse(timestamp);
  }

  // Preferences
  static Future<void> setPreference(String key, dynamic value) async {
    await Hive.box(_prefsBox).put(key, value);
  }

  static dynamic getPreference(String key) {
    return Hive.box(_prefsBox).get(key);
  }

  static Future<void> clearAll() async {
    await Hive.box(_sportsBox).clear();
    await Hive.box(_moviesBox).clear();
    await Hive.box(_prefsBox).clear();
  }
}
