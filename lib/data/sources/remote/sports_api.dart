import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../models/sport_event_model.dart';

class SportsApi {
  final Dio _dio;

  SportsApi(this._dio);

  Future<List<SportEventModel>> getLiveScores({String? sport, String? league}) async {
    try {
      final url = ApiEndpoints.liveScores(sport: sport, league: league);
      final response = await _dio.get(url);
      final data = response.data as List<dynamic>;
      return data
          .map((e) => SportEventModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      return [];
    }
  }

  Future<List<SportEventModel>> getUpcomingMatches({String? sport, String? league}) async {
    try {
      final url = ApiEndpoints.liveScores(sport: sport, league: league);
      final response = await _dio.get(url, queryParameters: {
        'status': 'eq.scheduled',
        'order': 'scraped_at.asc',
        'limit': '20',
      });
      final data = response.data as List<dynamic>;
      return data
          .map((e) => SportEventModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      return [];
    }
  }

  Future<List<SportEventModel>> getMatchHistory(String teamName) async {
    try {
      final url = ApiEndpoints.sportsTeams(teamName);
      final response = await _dio.get(url);
      final data = response.data as Map<String, dynamic>;
      final events = data['teams'] as List<dynamic>? ?? [];
      return events
          .map((e) => SportEventModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      return [];
    }
  }

  Future<Map<String, dynamic>> getTeamInfo(String teamName) async {
    try {
      final url = ApiEndpoints.sportsTeams(teamName);
      final response = await _dio.get(url);
      return response.data as Map<String, dynamic>;
    } on DioException {
      return {};
    }
  }
}
