import '../../../core/loading_state.dart';
import '../../../domain/entities/sport_event.dart';
import '../../../domain/entities/standing.dart';

class SportsState extends LoadingState<List<SportEvent>, String> {
  final String? selectedSport;
  final String selectedTournament;
  final Set<String> favoriteTeams;
  final bool showFavoritesOnly;
  final List<Standing> standings;

  const SportsState({
    super.isLoading,
    super.data,
    super.error,
    this.selectedSport,
    this.selectedTournament = 'all',
    this.favoriteTeams = const {},
    this.showFavoritesOnly = false,
    this.standings = const [],
  });

  List<SportEvent> get filteredScores {
    final scores = data;
    if (scores == null) return [];
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
  SportsState copyWith({
    bool? isLoading,
    List<SportEvent>? data,
    String? error,
    String? selectedSport,
    String? selectedTournament,
    Set<String>? favoriteTeams,
    bool? showFavoritesOnly,
    List<Standing>? standings,
  }) {
    return SportsState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
      selectedSport: selectedSport ?? this.selectedSport,
      selectedTournament: selectedTournament ?? this.selectedTournament,
      favoriteTeams: favoriteTeams ?? this.favoriteTeams,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      standings: standings ?? this.standings,
    );
  }

  @override
  List<Object?> get props => [
    isLoading, data, error, selectedSport, selectedTournament,
    favoriteTeams, showFavoritesOnly, standings,
  ];
}
