import '../../domain/entities/movie.dart';
import '../sources/remote/tmdb_api.dart';


class MovieRepository {
  final TmdbApi _tmdb;

  MovieRepository(this._tmdb);

  Future<List<Movie>> getPopular({int page = 1}) async {
    final models = await _tmdb.getPopular(page: page);
    return models.map((m) => m.toEntity()).toList();
  }

  Future<List<Movie>> search(String query, {int page = 1}) async {
    final models = await _tmdb.search(query, page: page);
    return models.map((m) => m.toEntity()).toList();
  }

  Future<List<Movie>> getByGenre(int genreId, {int page = 1}) async {
    final models = await _tmdb.getByGenre(genreId, page: page);
    return models.map((m) => m.toEntity()).toList();
  }
}
