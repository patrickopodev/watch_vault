import 'package:streamvault/design_system/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/team_flags.dart';
import '../../data/repositories/sports_repository.dart';
import '../../domain/entities/sport_event.dart';
import '../../injection/dependency_injection.dart';
import '../shared/widgets/score_badge.dart';
import 'bloc/sports_bloc.dart';
import 'bloc/sports_event.dart';
import 'bloc/sports_state.dart';
import 'widgets/league_filter_bar.dart';
import 'widgets/match_card.dart';
import 'widgets/standings_table.dart';

class SportsHomeScreen extends StatelessWidget {
  const SportsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SportsBloc(sl<SportsRepository>())..add(const LoadLiveScores()),
      child: const _SportsView(),
    );
  }
}

class _SportsView extends StatefulWidget {
  const _SportsView();

  @override
  State<_SportsView> createState() => _SportsViewState();
}

class _SportsViewState extends State<_SportsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SportsBloc>().add(const LoadStandings());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports'),
        actions: [
          BlocBuilder<SportsBloc, SportsState>(
            builder: (context, state) {
              if (state.hasData && state.favoriteTeams.isNotEmpty) {
                return IconButton(
                  icon: Icon(
                    state.showFavoritesOnly ? Icons.star : Icons.star_border,
                    color: state.showFavoritesOnly ? AppColors.warning : null,
                  ),
                  onPressed: () => context.read<SportsBloc>().add(SetShowFavorites(!state.showFavoritesOnly)),
                  tooltip: state.showFavoritesOnly ? 'Show all' : 'Show favorites',
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<SportsBloc>().add(const RefreshSports()),
          ),
        ],
      ),
      body: BlocBuilder<SportsBloc, SportsState>(
        builder: (context, state) {
          if (state.isLoading && !state.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading sports...'),
                ],
              ),
            );
          }
          if (state.hasError && !state.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.error!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.read<SportsBloc>().add(const RefreshSports()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          if (state.hasData) {
            final selectedSport = state.selectedSport;
            final selectedTournament = state.selectedTournament;
            final filteredScores = state.filteredScores;
            final liveScores = filteredScores.where((s) => s.isLive).toList();
            final todayMatches = filteredScores.where((s) => !s.isLive).toList();

            if (filteredScores.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sports_soccer, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No matches right now',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Check back later for live scores',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.read<SportsBloc>().add(const RefreshSports()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => context.read<SportsBloc>().add(RefreshSports(sport: selectedSport)),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: LeagueFilterBar(
                      selectedSport: selectedSport ?? 'all',
                      onSportSelected: (sport) {
                        context.read<SportsBloc>().add(LoadBySport(sport));
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          _TournamentChip(
                            label: '🌍 World Cup',
                            selected: selectedTournament == 'worldcup',
                            onTap: () => context.read<SportsBloc>().add(const FilterByTournament('worldcup')),
                          ),
                          const SizedBox(width: 8),
                          _TournamentChip(
                            label: '⚽ All',
                            selected: selectedTournament == 'all',
                            onTap: () => context.read<SportsBloc>().add(const FilterByTournament('all')),
                          ),
                          const SizedBox(width: 8),
                          _TournamentChip(
                            label: '🏆 UCL',
                            selected: selectedTournament == 'ucl',
                            onTap: () => context.read<SportsBloc>().add(const FilterByTournament('ucl')),
                          ),
                          const SizedBox(width: 8),
                          _TournamentChip(
                            label: '🏴󠁧󠁢󠁥󠁮󠁧󠁿 EPL',
                            selected: selectedTournament == 'epl',
                            onTap: () => context.read<SportsBloc>().add(const FilterByTournament('epl')),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (liveScores.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'LIVE',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${liveScores.length} matches',
                              style: AppTypography.labelSmall,
                            ),
                            const Spacer(),
                            Text(
                              'Auto-refresh 30s',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: liveScores.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final match = liveScores[index];
                          return LiveMatchPill(
                            match: match,
                            isFavorite: state.favoriteTeams.contains(match.homeTeam) || state.favoriteTeams.contains(match.awayTeam),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Row(
                        children: [
                          Text(
                            "Today's Matches",
                            style: AppTypography.titleMedium,
                          ),
                          const Spacer(),
                          if (state.showFavoritesOnly)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Favorites',
                                style: AppTypography.labelSmall.copyWith(color: AppColors.warning),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final match = todayMatches[index];
                        return MatchCard(
                          match: match,
                          isFavorite: state.favoriteTeams.contains(match.homeTeam) || state.favoriteTeams.contains(match.awayTeam),
                        );
                      },
                      childCount: todayMatches.length,
                    ),
                  ),
                  if (state.standings.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                        child: Text(
                          'Standings',
                          style: AppTypography.titleMedium,
                        ),
                      ),
                    ),
                  if (state.standings.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: StandingsTable(standings: state.standings),
                      ),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _TournamentChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TournamentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class LiveMatchPill extends StatelessWidget {
  final SportEvent match;
  final bool isFavorite;

  const LiveMatchPill({super.key, required this.match, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/sports/match/${match.matchId}?sport=${match.sport}'),
      child: Container(
        width: 130,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF13131A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEF4444), width: 2),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                '${teamFlagEmoji(match.homeTeam)} ${match.homeTeam}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 4),
            ScoreBadge(
              homeScore: match.homeScore?.toString(),
              awayScore: match.awayScore?.toString(),
              minute: match.minute,
              status: match.status,
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                '${teamFlagEmoji(match.awayTeam)} ${match.awayTeam}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
