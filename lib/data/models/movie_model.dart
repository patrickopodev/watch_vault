import '../../domain/entities/movie.dart';

class MovieModel {
  final String id;
  final String title;
  final String? overview;
  final String? posterUrl;
  final String? backdropUrl;
  final double? rating;
  final List<String> genres;
  final int? runtime;
  final String? year;
  final String? source;

  const MovieModel({
    required this.id,
    required this.title,
    this.overview,
    this.posterUrl,
    this.backdropUrl,
    this.rating,
    this.genres = const [],
    this.runtime,
    this.year,
    this.source,
  });

  factory MovieModel.fromTMDB(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'].toString(),
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      overview: json['overview'] as String?,
      posterUrl: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : null,
      backdropUrl: json['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/w1280${json['backdrop_path']}'
          : null,
      rating: (json['vote_average'] as num?)?.toDouble(),
      genres: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      runtime: json['runtime'] as int?,
      year: json['release_date'] != null
          ? (json['release_date'] as String).split('-').first
          : null,
      source: 'tmdb',
    );
  }

  factory MovieModel.fromInternetArchive(Map<String, dynamic> json) {
    return MovieModel(
      id: json['identifier'] as String? ?? '',
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      overview: json['description'] as String?,
      posterUrl: json['thumbnail_url'] as String?,
      backdropUrl: null,
      rating: null,
      genres: (json['subject'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      runtime: json['runtime'] as int?,
      year: json['year'] as String?,
      source: 'archive',
    );
  }

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
      rating: rating,
      genres: genres,
      runtime: runtime,
      year: year,
      source: source,
    );
  }
}
