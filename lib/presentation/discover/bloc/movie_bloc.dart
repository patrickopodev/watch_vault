import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_event.dart';
import 'movie_state.dart';
import '../../../data/repositories/movie_repository.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository _repository;

  MovieBloc(this._repository) : super(const MovieInitial()) {
    on<LoadPopularMovies>(_onLoadPopular);
    on<SearchMovies>(_onSearch);
    on<RefreshMovies>(_onRefresh);
    on<LoadByGenre>(_onLoadByGenre);
  }

  Future<void> _onLoadPopular(
    LoadPopularMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());
    try {
      final movies = await _repository.getPopular(page: event.page);
      emit(MovieLoaded(movies: movies));
    } catch (e) {
      emit(MovieError(message: e.toString()));
    }
  }

  Future<void> _onSearch(
    SearchMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());
    try {
      final movies = await _repository.search(event.query, page: event.page);
      emit(MovieLoaded(movies: movies));
    } catch (e) {
      emit(MovieError(message: e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshMovies event,
    Emitter<MovieState> emit,
  ) async {
    try {
      final movies = await _repository.getPopular(page: event.page);
      emit(MovieLoaded(movies: movies));
    } catch (e) {
      emit(MovieError(message: e.toString()));
    }
  }

  Future<void> _onLoadByGenre(
    LoadByGenre event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());
    try {
      final movies = await _repository.getByGenre(event.genreId, page: event.page);
      emit(MovieLoaded(movies: movies, selectedGenre: event.genreId));
    } catch (e) {
      emit(MovieError(message: e.toString()));
    }
  }
}
