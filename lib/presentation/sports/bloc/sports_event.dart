import 'package:equatable/equatable.dart';

abstract class SportsEvent extends Equatable {
  const SportsEvent();

  @override
  List<Object?> get props => [];
}

class LoadLiveScores extends SportsEvent {
  final String? sport;
  const LoadLiveScores({this.sport});

  @override
  List<Object?> get props => [sport];
}

class LoadBySport extends SportsEvent {
  final String sport;
  const LoadBySport(this.sport);

  @override
  List<Object?> get props => [sport];
}

class RefreshSports extends SportsEvent {
  final String? sport;
  const RefreshSports({this.sport});

  @override
  List<Object?> get props => [sport];
}

class FilterByTournament extends SportsEvent {
  final String tournament;
  const FilterByTournament(this.tournament);

  @override
  List<Object?> get props => [tournament];
}

class ToggleFavorite extends SportsEvent {
  final String teamName;
  const ToggleFavorite(this.teamName);

  @override
  List<Object?> get props => [teamName];
}

class SetShowFavorites extends SportsEvent {
  final bool show;
  const SetShowFavorites(this.show);

  @override
  List<Object?> get props => [show];
}

class LoadStandings extends SportsEvent {
  final String? league;
  const LoadStandings({this.league});

  @override
  List<Object?> get props => [league];
}
