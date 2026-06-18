import 'package:equatable/equatable.dart';
import '../../../domain/entities/sport_event.dart';

abstract class MatchDetailState extends Equatable {
  const MatchDetailState();

  @override
  List<Object?> get props => [];
}

class MatchDetailInitial extends MatchDetailState {
  const MatchDetailInitial();
}

class MatchDetailLoading extends MatchDetailState {
  const MatchDetailLoading();
}

class MatchDetailLoaded extends MatchDetailState {
  final SportEvent match;

  const MatchDetailLoaded({required this.match});

  @override
  List<Object?> get props => [match];
}

class MatchDetailError extends MatchDetailState {
  final String message;

  const MatchDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
