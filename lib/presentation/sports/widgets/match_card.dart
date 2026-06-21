import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:streamvault/design_system/ds.dart';
import '../../../core/utils/team_flags.dart';
import '../../../domain/entities/sport_event.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../shared/widgets/score_badge.dart';
import '../bloc/sports_bloc.dart';
import '../bloc/sports_event.dart';

class MatchCard extends StatelessWidget {
  final SportEvent match;
  final bool isFavorite;

  const MatchCard({super.key, required this.match, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/sports/match/${match.matchId}?sport=${match.sport}'),
      child: Container(
        height: 104,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: Text(teamFlagEmoji(match.homeTeam), style: const TextStyle(fontSize: 30)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        match.homeTeam,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: ScoreBadge(
                homeScore: match.homeScore?.toString(),
                awayScore: match.awayScore?.toString(),
                minute: match.minute,
                status: match.status,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        match.awayTeam,
                        textAlign: TextAlign.right,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: Text(teamFlagEmoji(match.awayTeam), style: const TextStyle(fontSize: 30)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? AppColors.warning : AppColors.textMuted,
                  size: 20,
                ),
                onPressed: () {
                  context.read<SportsBloc>().add(ToggleFavorite(match.homeTeam));
                  context.read<SportsBloc>().add(ToggleFavorite(match.awayTeam));
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
