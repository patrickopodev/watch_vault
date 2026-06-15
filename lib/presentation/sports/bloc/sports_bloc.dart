import 'package:flutter_bloc/flutter_bloc.dart';
import 'sports_event.dart';
import 'sports_state.dart';
import '../../../data/repositories/sports_repository.dart';

class SportsBloc extends Bloc<SportsEvent, SportsState> {
  final SportsRepository _repository;

  SportsBloc(this._repository) : super(const SportsInitial()) {
    on<LoadLiveScores>(_onLoadLiveScores);
    on<LoadBySport>(_onLoadBySport);
    on<RefreshSports>(_onRefresh);
    on<FilterByTournament>(_onFilterByTournament);
  }

  Future<void> _onLoadLiveScores(
    LoadLiveScores event,
    Emitter<SportsState> emit,
  ) async {
    emit(const SportsLoading());
    try {
      final scores = await _repository.getLiveScores(sport: event.sport);
      emit(SportsLoaded(scores: scores, selectedSport: event.sport));
    } catch (e) {
      emit(SportsError(message: e.toString()));
    }
  }

  Future<void> _onLoadBySport(
    LoadBySport event,
    Emitter<SportsState> emit,
  ) async {
    if (event.sport == 'all') {
      add(const LoadLiveScores());
    } else {
      add(LoadLiveScores(sport: event.sport));
    }
  }

  Future<void> _onRefresh(
    RefreshSports event,
    Emitter<SportsState> emit,
  ) async {
    try {
      final scores = await _repository.getLiveScores(sport: event.sport);
      emit(SportsLoaded(scores: scores, selectedSport: event.sport));
    } catch (e) {
      emit(SportsError(message: e.toString()));
    }
  }

  void _onFilterByTournament(
    FilterByTournament event,
    Emitter<SportsState> emit,
  ) {
    final current = state;
    if (current is SportsLoaded) {
      emit(SportsLoaded(
        scores: current.scores,
        selectedSport: current.selectedSport,
        selectedTournament: event.tournament,
      ));
    }
  }
}
