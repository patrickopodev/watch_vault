import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../domain/entities/sport_event.dart';

class StatsTab extends StatelessWidget {
  final SportEvent match;
  const StatsTab({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final homeScore = match.homeScore ?? 0;
    final awayScore = match.awayScore ?? 0;
    final totalScore = homeScore + awayScore;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        StatRow(
            label: 'Goals',
            home: homeScore.toString(),
            away: awayScore.toString(),
            homeRatio: totalScore > 0 ? homeScore / totalScore : 0.5),
        StatRow(
            label: 'Possession', home: '58%', away: '42%', homeRatio: 0.58),
        StatRow(label: 'Shots', home: '12', away: '8', homeRatio: 0.6),
        StatRow(
            label: 'Shots on Target', home: '5', away: '3', homeRatio: 0.625),
        StatRow(label: 'Corners', home: '7', away: '4', homeRatio: 0.636),
        StatRow(label: 'Fouls', home: '10', away: '14', homeRatio: 0.417),
        StatRow(
            label: 'Yellow Cards', home: '2', away: '3', homeRatio: 0.4),
        StatRow(label: 'Offsides', home: '1', away: '3', homeRatio: 0.25),
      ],
    );
  }
}

class StatRow extends StatelessWidget {
  final String label;
  final String home;
  final String away;
  final double homeRatio;

  const StatRow({
    super.key,
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
