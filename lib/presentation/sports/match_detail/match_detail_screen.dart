import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../bloc/match_detail_bloc.dart';
import '../bloc/match_detail_event.dart';
import '../bloc/match_detail_state.dart';
import 'shared/tab_bar_delegate.dart';
import 'widgets/match_header.dart';
import 'widgets/match_state_views.dart';
import 'widgets/timeline_tab.dart';
import 'widgets/stats_tab.dart';
import 'widgets/lineups_tab.dart';
import 'widgets/h2h_tab.dart';

class MatchDetailScreen extends StatelessWidget {
  final String matchId;
  final String sport;
  const MatchDetailScreen({super.key, required this.matchId, this.sport = 'football'});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchDetailBloc(matchId: matchId),
      child: _MatchDetailBody(sport: sport),
    );
  }
}

class _MatchDetailBody extends StatelessWidget {
  final String sport;
  const _MatchDetailBody({required this.sport});

  IconData get _sportIcon {
    switch (sport) {
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      case 'rugby':
        return Icons.sports_rugby;
      case 'cricket':
        return Icons.sports_cricket;
      case 'mma':
      case 'boxing':
        return Icons.sports_mma;
      default:
        return Icons.sports_soccer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: AppColors.background,
              flexibleSpace: FlexibleSpaceBar(
                background: BlocBuilder<MatchDetailBloc, MatchDetailState>(
                  builder: (context, state) {
                    if (state is MatchDetailLoaded) {
                      return MatchHeader(match: state.match, sportIcon: _sportIcon);
                    }
                    if (state is MatchDetailLoading) {
                      return const MatchLoadingView();
                    }
                    if (state is MatchDetailError) {
                      return MatchErrorView(
                        message: state.message,
                        onRetry: () => context.read<MatchDetailBloc>().add(const RefreshMatchDetail()),
                      );
                    }
                    return MatchPlaceholderView(sportIcon: _sportIcon);
                  },
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: MatchTabBarDelegate(
                TabBar(
                  tabs: const [
                    Tab(text: 'Timeline'),
                    Tab(text: 'Stats'),
                    Tab(text: 'Lineups'),
                    Tab(text: 'H2H'),
                  ],
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textMuted,
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            ),
            SliverFillRemaining(
              child: BlocBuilder<MatchDetailBloc, MatchDetailState>(
                builder: (context, state) {
                  if (state is MatchDetailLoaded) {
                    return TabBarView(
                      children: [
                        TimelineTab(match: state.match),
                        StatsTab(match: state.match),
                        LineupsTab(match: state.match),
                        H2HTab(match: state.match),
                      ],
                    );
                  }
                  return const TabBarView(
                    children: [
                      Center(child: Text('')),
                      Center(child: Text('')),
                      Center(child: Text('')),
                      Center(child: Text('')),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
