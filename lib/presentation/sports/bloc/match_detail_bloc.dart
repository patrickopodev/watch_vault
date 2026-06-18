import 'package:flutter_bloc/flutter_bloc.dart';
import 'match_detail_event.dart';
import 'match_detail_state.dart';
import '../../../data/repositories/sports_repository.dart';

class MatchDetailBloc extends Bloc<MatchDetailEvent, MatchDetailState> {
  final SportsRepository _repository;
  final String matchId;

  MatchDetailBloc(this._repository, this.matchId)
      : super(const MatchDetailInitial()) {
    on<LoadMatchDetail>(_onLoadMatchDetail);
    on<RefreshMatchDetail>(_onRefresh);
    add(const LoadMatchDetail());
  }

  Future<void> _onLoadMatchDetail(
    LoadMatchDetail event,
    Emitter<MatchDetailState> emit,
  ) async {
    emit(const MatchDetailLoading());
    try {
      final match = await _repository.getMatchById(matchId);
      if (match != null) {
        emit(MatchDetailLoaded(match: match));
      } else {
        emit(const MatchDetailError(message: 'Match not found'));
      }
    } catch (e) {
      emit(MatchDetailError(message: e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshMatchDetail event,
    Emitter<MatchDetailState> emit,
  ) async {
    try {
      final match = await _repository.getMatchById(matchId);
      if (match != null) {
        emit(MatchDetailLoaded(match: match));
      } else {
        emit(const MatchDetailError(message: 'Match not found'));
      }
    } catch (e) {
      emit(MatchDetailError(message: e.toString()));
    }
  }
}
