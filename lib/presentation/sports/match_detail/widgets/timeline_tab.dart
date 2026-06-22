import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../domain/entities/sport_event.dart';
import '../../../../domain/entities/timeline_event.dart';

class TimelineTab extends StatelessWidget {
  final SportEvent match;
  const TimelineTab({super.key, required this.match});

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
    final events = generateTimeline(
        match.homeTeam, match.awayTeam, match.homeScore, match.awayScore);
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 48, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text('No events yet',
                style: AppTypography.bodyLarge.copyWith(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: events.map((e) => TimelineEventWidget(event: e)).toList(),
    );
  }
}

class TimelineEventWidget extends StatelessWidget {
  final TimelineEvent event;
  const TimelineEventWidget({super.key, required this.event});

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
        mainAxisAlignment:
            event.isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
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
                    color: event.isHome
                        ? AppColors.primary
                        : AppColors.secondary),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_description(),
                          style: AppTypography.bodyMedium
                              .copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis),
                      if (event.player != null)
                        Text(event.player!,
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textMuted),
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
