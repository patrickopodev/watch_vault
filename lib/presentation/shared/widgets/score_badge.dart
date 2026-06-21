import 'package:streamvault/design_system/widgets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class ScoreBadge extends StatelessWidget {
  final String? homeScore;
  final String? awayScore;
  final String? minute;
  final String status;

  const ScoreBadge({
    super.key,
    this.homeScore,
    this.awayScore,
    this.minute,
    this.status = 'scheduled',
  });

  @override
  Widget build(BuildContext context) {
    final isLive = status == 'live';
    final isFinished = status == 'finished' || minute == 'FT';
    final isUpcoming = !isLive && !isFinished;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _scoreText,
          style: AppTypography.titleMedium.copyWith(
            color: isLive ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (isLive && minute != null) ...[
          const SizedBox(height: 2),
          Text(
            minute!,
            style: AppTypography.labelSmall.copyWith(color: AppColors.secondary),
          ),
        ],
        if (isFinished)
          Text(
            'FT',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
          ),
        if (isUpcoming && minute != null)
          Text(
            minute!,
            style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
          ),
      ],
    );
  }

  String get _scoreText {
    if (homeScore != null && awayScore != null) return '$homeScore - $awayScore';
    return 'VS';
  }
}
