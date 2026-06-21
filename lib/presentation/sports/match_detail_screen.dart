import 'package:streamvault/design_system/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/team_flags.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/repositories/sports_repository.dart';
import '../../../domain/entities/sport_event.dart';
import '../../../domain/entities/timeline_event.dart';
import '../../../injection/dependency_injection.dart';
import 'bloc/match_detail_bloc.dart';
import 'bloc/match_detail_event.dart';
import 'bloc/match_detail_state.dart';

class MatchDetailScreen extends StatelessWidget {
  final String matchId;
  final String sport;
  const MatchDetailScreen(
      {super.key, required this.matchId, this.sport = 'football'});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchDetailBloc(sl<SportsRepository>(), matchId),
      child: _MatchDetailView(sport: sport, matchId: matchId),
    );
  }
}

class _MatchDetailView extends StatelessWidget {
  final String sport;
  final String matchId;
  const _MatchDetailView({required this.sport, required this.matchId});

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
                      return _buildMatchHeader(context, state.match);
                    }
                    if (state is MatchDetailLoading) {
                      return _buildLoading();
                    }
                    if (state is MatchDetailError) {
                      return _buildError(context, state.message);
                    }
                    return _buildPlaceholder();
                  },
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
              child: BlocBuilder<MatchDetailBloc, MatchDetailState>(
                builder: (context, state) {
                  if (state is MatchDetailLoaded) {
                    return TabBarView(
                      children: [
                        _TimelineTab(match: state.match),
                        _StatsTab(match: state.match),
                        _LineupsTab(match: state.match),
                        _H2HTab(match: state.match),
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

  Widget _buildMatchHeader(BuildContext context, SportEvent match) {
    return _GradientContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TeamColumn(name: match.homeTeam, icon: _sportIcon, isHome: true),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      '${match.homeScore ?? '-'} - ${match.awayScore ?? '-'}',
                      style: AppTypography.displayLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _MatchStatusBadge(match: match),
                  ],
                ),
              ),
              _TeamColumn(
                  name: match.awayTeam, icon: _sportIcon, isHome: false),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return _GradientContainer(
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return _GradientContainer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white70, size: 48),
              const SizedBox(height: 16),
              Text(
                'Could not load match details',
                style: AppTypography.titleLarge.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: Colors.white60),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context
                    .read<MatchDetailBloc>()
                    .add(const RefreshMatchDetail()),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return _GradientContainer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_sportIcon, color: Colors.white38, size: 64),
            const SizedBox(height: 16),
            Text(
              'Loading match...',
              style: AppTypography.titleLarge.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientContainer extends StatelessWidget {
  final Widget child;
  const _GradientContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: child,
      ),
    );
  }
}

class _MatchStatusBadge extends StatelessWidget {
  final SportEvent match;
  const _MatchStatusBadge({required this.match});

  @override
  Widget build(BuildContext context) {
    if (match.isLive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '\u25CF LIVE',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    if (match.isFinished) {
      return Text(
        'FT',
        style: AppTypography.labelSmall.copyWith(
          color: Colors.white60,
          fontWeight: FontWeight.w700,
        ),
      );
    }
    return Text(
      match.minute,
      style: AppTypography.labelSmall.copyWith(
        color: Colors.white60,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _TeamColumn extends StatelessWidget {
  final String name;
  final bool isHome;
  final IconData icon;
  const _TeamColumn(
      {required this.name,
      required this.isHome,
      this.icon = Icons.sports_soccer});

  @override
  Widget build(BuildContext context) {
    final flag = teamFlagEmoji(name);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.surfaceElevated,
          child: flag.isNotEmpty
              ? Text(flag, style: const TextStyle(fontSize: 28))
              : Icon(icon, color: Colors.white, size: 28),
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
  final SportEvent match;
  const _TimelineTab({required this.match});

  @override
  Widget build(BuildContext context) {
    if (match.isUpcoming) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 48, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text('Match has not started yet',
                style: AppTypography.bodyLarge.copyWith(color: Colors.grey)),
          ],
        ),
      );
    }
    final events = generateTimeline(match.homeTeam, match.awayTeam, match.homeScore, match.awayScore);
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 48, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text('No events yet', style: AppTypography.bodyLarge.copyWith(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: events.map((e) => _TimelineEventWidget(event: e)).toList(),
    );
  }
}

class _TimelineEventWidget extends StatelessWidget {
  final TimelineEvent event;
  const _TimelineEventWidget({required this.event});

  IconData _iconForType() {
    switch (event.type) {
      case 'goal':
      case 'penalty':
      case 'own_goal':
        return Icons.sports_soccer;
      case 'yellow_card':
        return Icons.warning_amber;
      case 'red_card':
      case 'second_yellow':
        return Icons.gpp_bad;
      case 'substitution':
        return Icons.swap_horiz;
      default:
        return Icons.circle;
    }
  }

  String _description() {
    switch (event.type) {
      case 'goal':
        return 'Goal scored!';
      case 'penalty':
        return 'Penalty scored!';
      case 'own_goal':
        return 'Own goal!';
      case 'yellow_card':
        return 'Yellow Card';
      case 'red_card':
        return 'Red Card';
      case 'second_yellow':
        return 'Second Yellow';
      case 'substitution':
        return 'Substitution';
      default:
        return 'Event';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: event.isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!event.isHome) const Spacer(),
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: event.isHome
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(event.minute,
                    style: AppTypography.labelLarge
                        .copyWith(color: AppColors.secondary)),
                const SizedBox(width: 8),
                Icon(_iconForType(),
                    size: 16,
                    color: event.isHome ? AppColors.primary : AppColors.secondary),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_description(),
                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis),
                      if (event.player != null)
                        Text(event.player!,
                            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                            overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (event.isHome) const Spacer(),
        ],
      ),
    );
  }
}

class _StatsTab extends StatelessWidget {
  final SportEvent match;
  const _StatsTab({required this.match});

  @override
  Widget build(BuildContext context) {
    final homeScore = match.homeScore ?? 0;
    final awayScore = match.awayScore ?? 0;
    final totalScore = homeScore + awayScore;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatRow(
            label: 'Goals',
            home: homeScore.toString(),
            away: awayScore.toString(),
            homeRatio: totalScore > 0 ? homeScore / totalScore : 0.5),
        _StatRow(
            label: 'Possession', home: '58%', away: '42%', homeRatio: 0.58),
        _StatRow(label: 'Shots', home: '12', away: '8', homeRatio: 0.6),
        _StatRow(
            label: 'Shots on Target',
            home: '5',
            away: '3',
            homeRatio: 0.625),
        _StatRow(label: 'Corners', home: '7', away: '4', homeRatio: 0.636),
        _StatRow(label: 'Fouls', home: '10', away: '14', homeRatio: 0.417),
        _StatRow(
            label: 'Yellow Cards', home: '2', away: '3', homeRatio: 0.4),
        _StatRow(
            label: 'Offsides', home: '1', away: '3', homeRatio: 0.25),
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
                child: Text(home,
                    style: AppTypography.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600)),
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
                  style: AppTypography.bodyLarge
                      .copyWith(fontWeight: FontWeight.w600),
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
  final SportEvent match;
  const _LineupsTab({required this.match});

  @override
  Widget build(BuildContext context) {
    final homePlayers = [
      _Player('1', 'Goalkeeper', false),
      _Player('2', 'Right Back', false),
      _Player('4', 'Center Back', false),
      _Player('5', 'Center Back', false),
      _Player('3', 'Left Back', false),
      _Player('8', 'Midfielder', false),
      _Player('6', 'Def. Midfielder', false),
      _Player('10', 'Att. Midfielder', false),
      _Player('7', 'Right Wing', false),
      _Player('11', 'Left Wing', false),
      _Player('9', 'Striker', false),
    ];
    final awayPlayers = [
      _Player('1', 'Goalkeeper', true),
      _Player('2', 'Right Back', true),
      _Player('4', 'Center Back', true),
      _Player('5', 'Center Back', true),
      _Player('3', 'Left Back', true),
      _Player('8', 'Midfielder', true),
      _Player('6', 'Def. Midfielder', true),
      _Player('10', 'Att. Midfielder', true),
      _Player('7', 'Right Wing', true),
      _Player('11', 'Left Wing', true),
      _Player('9', 'Striker', true),
    ];

    final formation4 = [
      [homePlayers[0]],
      [homePlayers[1], homePlayers[2], homePlayers[3], homePlayers[4]],
      [homePlayers[5], homePlayers[6], homePlayers[7]],
      [homePlayers[8], homePlayers[9], homePlayers[10]],
    ];
    final formation4away = [
      [awayPlayers[0]],
      [awayPlayers[1], awayPlayers[2], awayPlayers[3], awayPlayers[4]],
      [awayPlayers[5], awayPlayers[6], awayPlayers[7]],
      [awayPlayers[8], awayPlayers[9], awayPlayers[10]],
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(match.homeTeam,
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        _FormationView(players: formation4, isHome: true),
        const SizedBox(height: 24),
        Divider(color: AppColors.textMuted.withValues(alpha: 0.3)),
        const SizedBox(height: 8),
        Text(match.awayTeam,
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        _FormationView(players: formation4away, isHome: false),
      ],
    );
  }
}

class _Player {
  final String number;
  final String name;
  final bool isAway;
  const _Player(this.number, this.name, this.isAway);
}

class _FormationView extends StatelessWidget {
  final List<List<_Player>> players;
  final bool isHome;
  const _FormationView({required this.players, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isHome ? '4-3-3' : '4-3-3',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: CustomPaint(
            painter: _PitchPainter(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: players.map((row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row.map((p) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isHome
                                ? AppColors.primary
                                : AppColors.secondary,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              p.number,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          width: 56,
                          child: Text(
                            p.name,
                            textAlign: TextAlign.center,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 9,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _PitchPainter extends CustomPainter {
  const _PitchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      20,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _H2HTab extends StatelessWidget {
  final SportEvent match;
  const _H2HTab({required this.match});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('Head to Head',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
        ),
        _H2HRow(home: match.homeTeam, away: match.awayTeam, score: '2 - 1'),
        _H2HRow(home: match.homeTeam, away: match.awayTeam, score: '1 - 1'),
        _H2HRow(home: match.homeTeam, away: match.awayTeam, score: '3 - 0'),
        _H2HRow(home: match.homeTeam, away: match.awayTeam, score: '0 - 2'),
        _H2HRow(home: match.homeTeam, away: match.awayTeam, score: '1 - 0'),
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
          Text(score,
              style: AppTypography.bodyLarge
                  .copyWith(fontWeight: FontWeight.w700)),
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
