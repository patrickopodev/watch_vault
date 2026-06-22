import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../domain/entities/sport_event.dart';

class LineupsTab extends StatelessWidget {
  final SportEvent match;
  const LineupsTab({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final homePlayers = [
      Player('1', 'Goalkeeper', false),
      Player('2', 'Right Back', false),
      Player('4', 'Center Back', false),
      Player('5', 'Center Back', false),
      Player('3', 'Left Back', false),
      Player('8', 'Midfielder', false),
      Player('6', 'Def. Midfielder', false),
      Player('10', 'Att. Midfielder', false),
      Player('7', 'Right Wing', false),
      Player('11', 'Left Wing', false),
      Player('9', 'Striker', false),
    ];
    final awayPlayers = [
      Player('1', 'Goalkeeper', true),
      Player('2', 'Right Back', true),
      Player('4', 'Center Back', true),
      Player('5', 'Center Back', true),
      Player('3', 'Left Back', true),
      Player('8', 'Midfielder', true),
      Player('6', 'Def. Midfielder', true),
      Player('10', 'Att. Midfielder', true),
      Player('7', 'Right Wing', true),
      Player('11', 'Left Wing', true),
      Player('9', 'Striker', true),
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
            style: AppTypography.titleMedium
                .copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        FormationView(players: formation4, isHome: true),
        const SizedBox(height: 24),
        Divider(color: AppColors.textMuted.withValues(alpha: 0.3)),
        const SizedBox(height: 8),
        Text(match.awayTeam,
            style: AppTypography.titleMedium
                .copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        FormationView(players: formation4away, isHome: false),
      ],
    );
  }
}

class Player {
  final String number;
  final String name;
  final bool isAway;
  const Player(this.number, this.name, this.isAway);
}

class FormationView extends StatelessWidget {
  final List<List<Player>> players;
  final bool isHome;
  const FormationView({super.key, required this.players, required this.isHome});

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
            painter: PitchPainter(),
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
                            border:
                                Border.all(color: Colors.white, width: 1.5),
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

class PitchPainter extends CustomPainter {
  const PitchPainter();

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
