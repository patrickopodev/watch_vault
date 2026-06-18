import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {
  const MovieInitial();
}

class MovieLoading extends MovieState {
  const MovieLoading();
}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final int? selectedGenre;

  const MovieLoaded({required this.movies, this.selectedGenre});

  @override
  List<Object?> get props => [movies, selectedGenre];
}

class MovieError extends MovieState {
  final String message;

  const MovieError({required this.message});

  @override
  List<Object?> get props => [message];
}
