import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/sports_repository.dart';
import '../../domain/entities/sport_event.dart';

class SportsCubit extends Cubit<SportsState> {
  final SportsRepository _repository;

  SportsCubit(this._repository) : super(SportsInitial());

  Future<void> loadLiveScores({String? sport}) async {
    emit(SportsLoading());
    try {
      final scores = await _repository.getLiveScores(sport: sport);
      emit(SportsLoaded(scores: scores, selectedSport: sport));
    } catch (e) {
      emit(SportsError(message: e.toString()));
    }
  }

  Future<void> loadBySport(String sport) async {
    if (sport == 'all') {
      await loadLiveScores();
    } else {
      await loadLiveScores(sport: sport);
    }
  }

  Future<void> refresh({String? sport}) => loadLiveScores(sport: sport);
}

abstract class SportsState {}

class SportsInitial extends SportsState {}

class SportsLoading extends SportsState {}

class SportsLoaded extends SportsState {
  final List<SportEvent> scores;
  final String? selectedSport;

  SportsLoaded({required this.scores, this.selectedSport});
}

class SportsError extends SportsState {
  final String message;
  SportsError({required this.message});
}
