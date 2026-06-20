import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../domain/entities/standing.dart';
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

  Future<List<Standing>> getStandings({String? league}) async {
    try {
      final url = ApiEndpoints.standings(league: league);
      final response = await _dio.get(url);
      final data = response.data as List<dynamic>;
      return data.map((e) {
        final m = e as Map<String, dynamic>;
        return Standing(
          position: (m['position'] as num?)?.toInt() ?? 0,
          teamName: m['team_name'] as String? ?? '',
          played: (m['played'] as num?)?.toInt() ?? 0,
          won: (m['won'] as num?)?.toInt() ?? 0,
          drawn: (m['drawn'] as num?)?.toInt() ?? 0,
          lost: (m['lost'] as num?)?.toInt() ?? 0,
          goalsFor: (m['goals_for'] as num?)?.toInt() ?? 0,
          goalsAgainst: (m['goals_against'] as num?)?.toInt() ?? 0,
          goalDifference: (m['goal_difference'] as num?)?.toInt() ?? 0,
          points: (m['points'] as num?)?.toInt() ?? 0,
          league: m['league'] as String?,
          teamLogo: m['team_logo'] as String?,
        );
      }).toList();
    } on DioException {
      return [];
    }
  }
}
