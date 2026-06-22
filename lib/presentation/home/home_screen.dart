import 'package:streamvault/design_system/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../data/repositories/movie_repository.dart';
import '../../data/repositories/sports_repository.dart';
import '../../injection/dependency_injection.dart';
import '../discover/bloc/movie_bloc.dart';
import '../discover/bloc/movie_event.dart';
import '../discover/bloc/movie_state.dart';
import '../sports/bloc/sports_bloc.dart';
import '../sports/bloc/sports_event.dart';
import '../sports/bloc/sports_state.dart';

import 'widgets/featured_banner.dart';
import 'widgets/trending_row.dart';
import 'widgets/live_now_row.dart';
import 'widgets/free_to_watch_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SportsBloc(sl<SportsRepository>())..add(const LoadLiveScores()),
        ),
        BlocProvider(
          create: (_) => MovieBloc(sl<MovieRepository>())..add(const LoadPopularMovies()),
        ),
      ],
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'SV',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'StreamVault',
                style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surfaceElevated,
                child: Icon(Icons.person, size: 18, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoaded && state.movies.isNotEmpty) {
                  return FeaturedBanner(featured: state.movies.first);
                }
                return const FeaturedBanner();
              },
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: 'Live Now', trailing: '🔴'),
            ),
            BlocBuilder<SportsBloc, SportsState>(
              builder: (context, state) {
                if (state is SportsLoaded) {
                  final live = state.scores.where((s) => s.isLive).toList();
                  return LiveNowRow(matches: live);
                }
                return const LiveNowRow();
              },
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: 'Trending Movies', trailing: 'See all'),
            ),
            BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoaded) {
                  return TrendingRow(movies: state.movies);
                }
                return const TrendingRow();
              },
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: "Today's Matches", trailing: 'See all'),
            ),
            BlocBuilder<SportsBloc, SportsState>(
              builder: (context, state) {
                if (state is SportsLoaded) {
                  final matches = state.scores;
                  if (matches.isEmpty) {
                    return const SizedBox(
                      height: 80,
                      child: Center(child: Text('No matches today')),
                    );
                  }
                  return SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: matches.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, index) {
                        final match = matches[index];
                        return Container(
                          width: 200,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  match.homeTeam,
                                  style: AppTypography.bodyMedium.copyWith(fontSize: 11),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${match.homeScore ?? '-'} - ${match.awayScore ?? '-'}',
                                    style: AppTypography.titleMedium.copyWith(fontSize: 14),
                                  ),
                                  Text(
                                    match.isLive ? 'LIVE' : match.minute,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: match.isLive ? AppColors.danger : AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  match.awayTeam,
                                  style: AppTypography.bodyMedium.copyWith(fontSize: 11),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox(height: 80);
              },
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: 'Top Creators', trailing: 'See all'),
            ),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, __) => Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.surfaceElevated,
                      child: Icon(Icons.person, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 4),
                    Text('Creator', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                    Text('24K', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: 'Free to Watch', trailing: 'See all'),
            ),
            BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoaded) {
                  return FreeToWatchGrid(movies: state.movies);
                }
                return const FreeToWatchGrid();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String trailing;
  const SectionHeader({super.key, required this.title, this.trailing = 'See all'});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.titleMedium),
        Text(
          trailing,
          style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
