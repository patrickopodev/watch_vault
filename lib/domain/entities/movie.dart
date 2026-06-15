class Movie {
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

  const Movie({
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

  Movie copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterUrl,
    String? backdropUrl,
    double? rating,
    List<String>? genres,
    int? runtime,
    String? year,
    String? source,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      rating: rating ?? this.rating,
      genres: genres ?? this.genres,
      runtime: runtime ?? this.runtime,
      year: year ?? this.year,
      source: source ?? this.source,
    );
  }
}
