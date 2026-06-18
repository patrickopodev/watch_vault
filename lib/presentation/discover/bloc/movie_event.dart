import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class LoadPopularMovies extends MovieEvent {
  final int page;
  const LoadPopularMovies({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class SearchMovies extends MovieEvent {
  final String query;
  final int page;
  const SearchMovies({required this.query, this.page = 1});

  @override
  List<Object?> get props => [query, page];
}

class RefreshMovies extends MovieEvent {
  final int page;
  const RefreshMovies({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class LoadByGenre extends MovieEvent {
  final int genreId;
  final int page;
  const LoadByGenre({required this.genreId, this.page = 1});

  @override
  List<Object?> get props => [genreId, page];
}
