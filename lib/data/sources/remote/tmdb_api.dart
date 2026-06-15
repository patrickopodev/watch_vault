import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../models/movie_model.dart';

class TmdbApi {
  final Dio _dio;
  final String _apiKey;

  TmdbApi(this._dio, this._apiKey);

  Future<List<MovieModel>> getPopular({int page = 1}) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.tmdbBase}/movie/popular',
        queryParameters: {'api_key': _apiKey, 'page': page},
      );
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      return results
          .map((e) => MovieModel.fromTMDB(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      return [];
    }
  }

  Future<List<MovieModel>> search(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.tmdbBase}/search/movie',
        queryParameters: {'api_key': _apiKey, 'query': query, 'page': page},
      );
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      return results
          .map((e) => MovieModel.fromTMDB(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      return [];
    }
  }

  Future<List<MovieModel>> getByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.tmdbBase}/discover/movie',
        queryParameters: {
          'api_key': _apiKey,
          'with_genres': genreId,
          'page': page,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      return results
          .map((e) => MovieModel.fromTMDB(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      return [];
    }
  }
}
