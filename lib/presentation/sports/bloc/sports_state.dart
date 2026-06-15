import 'package:equatable/equatable.dart';
import '../../../domain/entities/sport_event.dart';

abstract class SportsState extends Equatable {
  const SportsState();

  @override
  List<Object?> get props => [];
}

class SportsInitial extends SportsState {
  const SportsInitial();
}

class SportsLoading extends SportsState {
  const SportsLoading();
}

class SportsLoaded extends SportsState {
  final List<SportEvent> scores;
  final String? selectedSport;

  const SportsLoaded({required this.scores, this.selectedSport});

  @override
  List<Object?> get props => [scores, selectedSport];
}

class SportsError extends SportsState {
  final String message;

  const SportsError({required this.message});

  @override
  List<Object?> get props => [message];
}
