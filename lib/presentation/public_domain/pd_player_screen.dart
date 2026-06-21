import 'package:streamvault/design_system/widgets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class PDPlayerScreen extends StatelessWidget {
  final String videoId;
  const PDPlayerScreen({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.play_circle_outline, size: 56, color: Colors.white54),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.cast, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: Colors.white,
                          ),
                          child: const Slider(value: 0.3, onChanged: null),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('15:30', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.volume_up, color: Colors.white, size: 18),
                                  onPressed: () {},
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '720p',
                                    style: AppTypography.labelSmall.copyWith(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.fullscreen, color: Colors.white, size: 18),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            Text('1h 42m', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Movie Title (1960)',
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '1h 42m · Drama · Classic',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'A classic film from the golden age of cinema. This public domain masterpiece tells a story of love, loss, and redemption.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ActionChip(icon: Icons.download, label: 'Download'),
                    const SizedBox(width: 8),
                    _ActionChip(icon: Icons.bookmark_border, label: 'Watchlist'),
                    const SizedBox(width: 8),
                    _ActionChip(icon: Icons.share_outlined, label: 'Share'),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'More Like This',
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, __) => Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: const Color(0xFF2A2A3D)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
