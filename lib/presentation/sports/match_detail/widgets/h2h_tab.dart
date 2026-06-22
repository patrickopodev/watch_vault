import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../domain/entities/sport_event.dart';

class H2HTab extends StatelessWidget {
  final SportEvent match;
  const H2HTab({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('Head to Head',
              style: AppTypography.titleMedium
                  .copyWith(fontWeight: FontWeight.w700)),
        ),
        H2HRow(home: match.homeTeam, away: match.awayTeam, score: '2 - 1'),
        H2HRow(home: match.homeTeam, away: match.awayTeam, score: '1 - 1'),
        H2HRow(home: match.homeTeam, away: match.awayTeam, score: '3 - 0'),
        H2HRow(home: match.homeTeam, away: match.awayTeam, score: '0 - 2'),
        H2HRow(home: match.homeTeam, away: match.awayTeam, score: '1 - 0'),
      ],
    );
  }
}

class H2HRow extends StatelessWidget {
  final String home;
  final String away;
  final String score;

  const H2HRow({
    super.key,
    required this.home,
    required this.away,
    required this.score,
  });

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
