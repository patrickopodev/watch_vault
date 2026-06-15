import 'package:streamvault/design_system/ds.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
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
      create: (_) => SportsBloc(
        sl<SportsRepository>(),
      )..add(const LoadLiveScores()),
      child: const _SportsView(),
    );
  }
}

class _SportsView extends StatelessWidget {
  const _SportsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<SportsBloc>().add(const RefreshSports()),
          ),
        ],
      ),
      body: BlocBuilder<SportsBloc, SportsState>(
        builder: (context, state) {
          if (state is SportsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SportsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                  const SizedBox(height: 16),
                  Text(state.message),
                ],
              ),
            );
          }
          if (state is SportsLoaded) {
            final selectedSport = state.selectedSport;
            final liveScores = state.scores.where((s) => s.isLive).toList();
            final todayMatches = state.scores.where((s) => !s.isLive).toList();

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
                          return LiveMatchPill(match: match);
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        "Today's Matches",
                        style: AppTypography.titleMedium,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final match = todayMatches[index];
                        return MatchCard(match: match);
                      },
                      childCount: todayMatches.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        'Standings',
                        style: AppTypography.titleMedium,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: StandingsTable(),
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

class LiveMatchPill extends StatelessWidget {
  final SportEvent match;
  const LiveMatchPill({super.key, required this.match});

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
                match.homeTeam,
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
                match.awayTeam,
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
