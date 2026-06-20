import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sports_event.dart';
import 'sports_state.dart';
import '../../../data/repositories/sports_repository.dart';
import '../../../domain/entities/standing.dart';

class SportsBloc extends Bloc<SportsEvent, SportsState> {
  final SportsRepository _repository;
  Timer? _autoRefreshTimer;

  SportsBloc(this._repository) : super(const SportsInitial()) {
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
    emit(const SportsLoading());
    try {
      final scores = await _repository.getLiveScores(sport: event.sport);
      final favorites = Set<String>.from(_repository.getFavoriteTeams());
      emit(SportsLoaded(scores: scores, selectedSport: event.sport, favoriteTeams: favorites));
      _startAutoRefresh(event.sport);
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
      final current = state;
      final favorites = current is SportsLoaded ? current.favoriteTeams : <String>{};
      final showFavs = current is SportsLoaded ? current.showFavoritesOnly : false;
      final standings = current is SportsLoaded ? current.standings : const <Standing>[];
      emit(SportsLoaded(
        scores: scores,
        selectedSport: event.sport,
        favoriteTeams: favorites,
        showFavoritesOnly: showFavs,
        standings: standings,
      ));
      _startAutoRefresh(event.sport);
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
        favoriteTeams: current.favoriteTeams,
        showFavoritesOnly: current.showFavoritesOnly,
        standings: current.standings,
      ));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<SportsState> emit,
  ) async {
    final current = state;
    if (current is SportsLoaded) {
      final updated = Set<String>.from(current.favoriteTeams);
      if (updated.contains(event.teamName)) {
        updated.remove(event.teamName);
      } else {
        updated.add(event.teamName);
      }
      await _repository.setFavoriteTeams(updated.toList());
      emit(SportsLoaded(
        scores: current.scores,
        selectedSport: current.selectedSport,
        selectedTournament: current.selectedTournament,
        favoriteTeams: updated,
        showFavoritesOnly: current.showFavoritesOnly,
        standings: current.standings,
      ));
    }
  }

  void _onSetShowFavorites(
    SetShowFavorites event,
    Emitter<SportsState> emit,
  ) {
    final current = state;
    if (current is SportsLoaded) {
      emit(SportsLoaded(
        scores: current.scores,
        selectedSport: current.selectedSport,
        selectedTournament: current.selectedTournament,
        favoriteTeams: current.favoriteTeams,
        showFavoritesOnly: event.show,
        standings: current.standings,
      ));
    }
  }

  Future<void> _onLoadStandings(
    LoadStandings event,
    Emitter<SportsState> emit,
  ) async {
    final current = state;
    if (current is! SportsLoaded) return;
    try {
      final standings = await _repository.getStandings(league: event.league);
      emit(SportsLoaded(
        scores: current.scores,
        selectedSport: current.selectedSport,
        selectedTournament: current.selectedTournament,
        favoriteTeams: current.favoriteTeams,
        showFavoritesOnly: current.showFavoritesOnly,
        standings: standings,
      ));
    } catch (_) {}
  }
}
