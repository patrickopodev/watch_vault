import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../domain/entities/sport_event.dart';

class MatchStatusBadge extends StatelessWidget {
  final SportEvent match;
  const MatchStatusBadge({super.key, required this.match});

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
