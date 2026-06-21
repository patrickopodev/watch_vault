import 'package:streamvault/design_system/widgets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../domain/entities/standing.dart';

class StandingsTable extends StatelessWidget {
  final List<Standing> standings;

  const StandingsTable({super.key, this.standings = const []});

  @override
  Widget build(BuildContext context) {
    if (standings.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildHeader(),
          ...standings.asMap().entries.map((e) => _buildRow(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: AppColors.surfaceElevated,
      child: Row(
        children: [
          _cell('#', 28),
          _cell('Club', null, flex: true),
          _cell('P', 28),
          _cell('W', 28),
          _cell('D', 28),
          _cell('L', 28),
          _cell('GD', 36),
          _cell('Pts', 36),
        ],
      ),
    );
  }

  Widget _cell(String text, double? width, {bool flex = false}) {
    final widget = Text(
      text,
      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
    );
    if (flex) return Expanded(child: widget);
    return SizedBox(width: width, child: widget);
  }

  Widget _buildRow(int index, Standing standing) {
    final isTop4 = index < 4;
    final isRelegation = index >= standings.length - 2;

    return Container(
      height: 48,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: isTop4
                ? AppColors.primary
                : isRelegation
                    ? AppColors.danger
                    : Colors.transparent,
            width: 3,
          ),
          bottom: const BorderSide(color: Color(0xFF1C1C26)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${standing.position}',
              style: AppTypography.bodyLarge.copyWith(color: AppColors.textMuted),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1C1C26),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  standing.teamName,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _stat(standing.played, 28),
          _stat(standing.won, 28),
          _stat(standing.drawn, 28),
          _stat(standing.lost, 28),
          _stat(standing.goalDifference, 36),
          SizedBox(
            width: 36,
            child: Text(
              '${standing.points}',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(dynamic value, double width) {
    return SizedBox(
      width: width,
      child: Text(
        '$value',
        style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
