import 'package:streamvault/design_system/ds.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class StandingsTable extends StatelessWidget {
  const StandingsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildHeader(),
          ..._mockStandings.asMap().entries.map((e) => _buildRow(e.key, e.value)),
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

  Widget _buildRow(int index, _StandingRow standing) {
    final isTop4 = index < 4;
    final isRelegation = index >= _mockStandings.length - 2;

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
              '${index + 1}',
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
                  standing.name,
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
          _stat(standing.gd, 36),
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

class _StandingRow {
  final String name;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int gd;
  final int points;
  const _StandingRow({
    required this.name,
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.gd = 0,
    this.points = 0,
  });
}

const _mockStandings = [
  _StandingRow(name: 'Manchester City', played: 28, won: 20, drawn: 5, lost: 3, gd: 45, points: 65),
  _StandingRow(name: 'Liverpool', played: 28, won: 19, drawn: 7, lost: 2, gd: 38, points: 64),
  _StandingRow(name: 'Arsenal', played: 28, won: 18, drawn: 6, lost: 4, gd: 32, points: 60),
  _StandingRow(name: 'Aston Villa', played: 28, won: 17, drawn: 5, lost: 6, gd: 20, points: 56),
  _StandingRow(name: 'Tottenham', played: 28, won: 16, drawn: 5, lost: 7, gd: 15, points: 53),
  _StandingRow(name: 'Manchester United', played: 28, won: 14, drawn: 8, lost: 6, gd: 10, points: 50),
  _StandingRow(name: 'West Ham', played: 28, won: 12, drawn: 8, lost: 8, gd: 2, points: 44),
  _StandingRow(name: 'Chelsea', played: 28, won: 11, drawn: 7, lost: 10, gd: -3, points: 40),
];
