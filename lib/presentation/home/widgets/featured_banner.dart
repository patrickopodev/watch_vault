import 'package:streamvault/design_system/widgets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Color(0xFF0A0A0F)],
          stops: [0.3, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.surfaceElevated,
                  AppColors.surfaceElevated.withValues(alpha: 0.5),
                ],
              ),
            ),
            child: const Center(
              child: Icon(Icons.movie, size: 80, color: Color(0xFF50505F)),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _GenreChip('Action'),
                    const SizedBox(width: 8),
                    _GenreChip('Adventure'),
                    const SizedBox(width: 8),
                    _GenreChip('Sci-Fi'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Featured Movie Title',
                  style: AppTypography.displayMedium.copyWith(color: Colors.white),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  'An epic adventure across the galaxy',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ActionButton(label: 'Watch Now', isPrimary: true),
                    const SizedBox(width: 10),
                    _ActionButton(label: '+ Watchlist', isPrimary: false),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Available on: ', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                    ...List.generate(3, (_) => Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Dot(isActive: true),
                  _Dot(isActive: false),
                  _Dot(isActive: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String label;
  const _GenreChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  const _ActionButton({required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: const Color(0xFF2A2A3D)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;
  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isActive ? 20 : 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.textMuted,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
