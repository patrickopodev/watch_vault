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
