import 'package:flutter/material.dart';
import '../../../../core/utils/team_flags.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../domain/entities/sport_event.dart';
import '../shared/gradient_container.dart';
import '../shared/match_status_badge.dart';

class MatchHeader extends StatelessWidget {
  final SportEvent match;
  final IconData sportIcon;
  const MatchHeader({super.key, required this.match, this.sportIcon = Icons.sports_soccer});

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TeamColumn(name: match.homeTeam, icon: sportIcon, isHome: true),
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
                    MatchStatusBadge(match: match),
                  ],
                ),
              ),
              TeamColumn(name: match.awayTeam, icon: sportIcon, isHome: false),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class TeamColumn extends StatelessWidget {
  final String name;
  final bool isHome;
  final IconData icon;
  const TeamColumn({super.key, required this.name, required this.isHome, this.icon = Icons.sports_soccer});

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
