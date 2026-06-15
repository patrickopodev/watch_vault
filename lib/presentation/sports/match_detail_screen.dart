import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class MatchDetailScreen extends StatelessWidget {
  final String matchId;
  final String sport;
  const MatchDetailScreen({super.key, required this.matchId, this.sport = 'football'});

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
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E3A5F), Color(0xFF5B21B6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.6],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _TeamColumn(name: 'Home', icon: _sportIcon, isHome: true),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  Text(
                                    '2 - 1',
                                    style: AppTypography.displayLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '● LIVE',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _TeamColumn(name: 'Away', icon: _sportIcon, isHome: false),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
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
              child: TabBarView(
                children: [
                  _TimelineTab(),
                  _StatsTab(),
                  _LineupsTab(),
                  _H2HTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamColumn extends StatelessWidget {
  final String name;
  final bool isHome;
  final IconData icon;
  const _TeamColumn({required this.name, required this.isHome, this.icon = Icons.sports_soccer});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.surfaceElevated,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: AppTypography.titleLarge.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _TimelineTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _TimelineEvent(minute: "12'", icon: Icons.sports_soccer, description: 'Goal by Player A', isHome: true),
        _TimelineEvent(minute: "34'", icon: Icons.sports_soccer, description: 'Goal by Player B', isHome: false),
        _TimelineEvent(minute: "45+2'", icon: Icons.warning_amber, description: 'Yellow Card - Player C', isHome: true),
        _TimelineEvent(minute: "67'", icon: Icons.sports_soccer, description: 'Goal by Player D', isHome: true),
        _TimelineEvent(minute: "78'", icon: Icons.swap_horiz, description: 'Substitution - Player E', isHome: false),
      ],
    );
  }
}

class _TimelineEvent extends StatelessWidget {
  final String minute;
  final IconData icon;
  final String description;
  final bool isHome;

  const _TimelineEvent({
    required this.minute,
    required this.icon,
    required this.description,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isHome) const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHome ? AppColors.primary.withValues(alpha: 0.1) : AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(minute, style: AppTypography.labelLarge.copyWith(color: AppColors.secondary)),
                const SizedBox(width: 8),
                Icon(icon, size: 16, color: isHome ? AppColors.primary : AppColors.secondary),
                const SizedBox(width: 8),
                SizedBox(
                  width: 200,
                  child: Text(
                    description,
                    style: AppTypography.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (isHome) const Spacer(),
        ],
      ),
    );
  }
}

class _StatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatRow(label: 'Possession', home: '58%', away: '42%', homeRatio: 0.58),
        _StatRow(label: 'Shots', home: '12', away: '8', homeRatio: 0.6),
        _StatRow(label: 'Shots on Target', home: '5', away: '3', homeRatio: 0.625),
        _StatRow(label: 'Corners', home: '7', away: '4', homeRatio: 0.636),
        _StatRow(label: 'Fouls', home: '10', away: '14', homeRatio: 0.417),
        _StatRow(label: 'Yellow Cards', home: '2', away: '3', homeRatio: 0.4),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String home;
  final String away;
  final double homeRatio;

  const _StatRow({
    required this.label,
    required this.home,
    required this.away,
    required this.homeRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(home, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              ),
              Expanded(
                child: Center(
                  child: Text(label, style: AppTypography.bodyMedium),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  away,
                  textAlign: TextAlign.right,
                  style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(
                  flex: (homeRatio * 100).round(),
                  child: Container(height: 4, color: AppColors.primary),
                ),
                Expanded(
                  flex: ((1 - homeRatio) * 100).round(),
                  child: Container(height: 4, color: AppColors.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineupsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Lineups', style: AppTypography.bodyMedium),
    );
  }
}

class _H2HTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _H2HRow(home: 'Home', away: 'Away', score: '2 - 1'),
        _H2HRow(home: 'Home', away: 'Away', score: '1 - 1'),
        _H2HRow(home: 'Home', away: 'Away', score: '3 - 0'),
        _H2HRow(home: 'Home', away: 'Away', score: '0 - 2'),
        _H2HRow(home: 'Home', away: 'Away', score: '1 - 0'),
      ],
    );
  }
}

class _H2HRow extends StatelessWidget {
  final String home;
  final String away;
  final String score;

  const _H2HRow({required this.home, required this.away, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(home, style: AppTypography.bodyMedium),
          Text(score, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
          Text(away, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _TabBarDelegate old) => false;
}
