import 'package:equatable/equatable.dart';
import '../../../domain/entities/sport_event.dart';
import '../../../domain/entities/standing.dart';

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
  final Set<String> favoriteTeams;
  final bool showFavoritesOnly;
  final List<Standing> standings;

  const SportsLoaded({
    required this.scores,
    this.selectedSport,
    this.selectedTournament = 'all',
    this.favoriteTeams = const {},
    this.showFavoritesOnly = false,
    this.standings = const [],
  });

  List<SportEvent> get filteredScores {
    var filtered = scores;
    if (selectedTournament != 'all') {
      filtered = filtered.where((s) {
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
    if (showFavoritesOnly) {
      filtered = filtered.where((s) =>
        favoriteTeams.contains(s.homeTeam) || favoriteTeams.contains(s.awayTeam)
      ).toList();
    }
    return filtered;
  }

  @override
  List<Object?> get props => [scores, selectedSport, selectedTournament, favoriteTeams, showFavoritesOnly, standings];
}

class SportsError extends SportsState {
  final String message;

  const SportsError({required this.message});

  @override
  List<Object?> get props => [message];
}
