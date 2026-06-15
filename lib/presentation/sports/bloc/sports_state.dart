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
  final String selectedTournament;

  const SportsLoaded({
    required this.scores,
    this.selectedSport,
    this.selectedTournament = 'all',
  });

  List<SportEvent> get filteredScores {
    if (selectedTournament == 'all') return scores;
    return scores.where((s) {
      switch (selectedTournament) {
        case 'worldcup':
          return s.league?.contains('World Cup') == true || s.league?.contains('FIFA') == true;
        case 'ucl':
          return s.league?.contains('Champions League') == true;
        case 'epl':
          return s.league?.contains('Premier League') == true;
        default:
          return true;
      }
    }).toList();
  }

  @override
  List<Object?> get props => [scores, selectedSport, selectedTournament];
}

class SportsError extends SportsState {
  final String message;

  const SportsError({required this.message});

  @override
  List<Object?> get props => [message];
}
