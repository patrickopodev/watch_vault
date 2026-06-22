import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/logger.dart';
import '../../../data/repositories/sports_repository.dart';
import 'sports_event.dart';
import 'sports_state.dart';

class SportsBloc extends Bloc<SportsEvent, SportsState> {
  final SportsRepository _repository;
  Timer? _autoRefreshTimer;

  SportsBloc(this._repository) : super(const SportsState()) {
    on<LoadLiveScores>(_onLoadLiveScores);
    on<LoadBySport>(_onLoadBySport);
    on<RefreshSports>(_onRefresh);
    on<FilterByTournament>(_onFilterByTournament);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SetShowFavorites>(_onSetShowFavorites);
    on<LoadStandings>(_onLoadStandings);
  }

  void _startAutoRefresh(String? sport) {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      add(RefreshSports(sport: sport));
    });
  }

  @override
  Future<void> close() {
    _autoRefreshTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadLiveScores(
    LoadLiveScores event,
    Emitter<SportsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final scores = await _repository.getLiveScores(sport: event.sport);
      final favorites = Set<String>.from(_repository.getFavoriteTeams());
      emit(state.copyWith(
        isLoading: false,
        data: scores,
        error: null,
        selectedSport: event.sport,
        favoriteTeams: favorites,
      ));
      _startAutoRefresh(event.sport);
    } catch (e, stack) {
      Logger.log(LogLevel.error, 'LoadLiveScores failed', error: e, stack: stack);
      emit(state.copyWith(isLoading: false, error: e.toString()));
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
      emit(state.copyWith(
        isLoading: false,
        data: scores,
        error: null,
        selectedSport: event.sport,
      ));
      _startAutoRefresh(event.sport);
    } catch (e, stack) {
      Logger.log(LogLevel.error, 'RefreshSports failed', error: e, stack: stack);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onFilterByTournament(
    FilterByTournament event,
    Emitter<SportsState> emit,
  ) {
    emit(state.copyWith(selectedTournament: event.tournament));
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<SportsState> emit,
  ) async {
    final updated = Set<String>.from(state.favoriteTeams);
    if (updated.contains(event.teamName)) {
      updated.remove(event.teamName);
    } else {
      updated.add(event.teamName);
    }
    await _repository.setFavoriteTeams(updated.toList());
    emit(state.copyWith(favoriteTeams: updated));
  }

  void _onSetShowFavorites(
    SetShowFavorites event,
    Emitter<SportsState> emit,
  ) {
    emit(state.copyWith(showFavoritesOnly: event.show));
  }

  Future<void> _onLoadStandings(
    LoadStandings event,
    Emitter<SportsState> emit,
  ) async {
    try {
      final standings = await _repository.getStandings(league: event.league);
      emit(state.copyWith(standings: standings));
    } catch (e, stack) {
      Logger.log(LogLevel.warning, 'LoadStandings failed', error: e, stack: stack);
    }
  }
}
