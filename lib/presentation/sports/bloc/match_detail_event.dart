import 'package:equatable/equatable.dart';

abstract class MatchDetailEvent extends Equatable {
  const MatchDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadMatchDetail extends MatchDetailEvent {
  const LoadMatchDetail();
}

class RefreshMatchDetail extends MatchDetailEvent {
  const RefreshMatchDetail();
}
