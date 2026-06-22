import 'package:flutter/material.dart';
import '../../../../core/constants/app_typography.dart';
import '../shared/gradient_container.dart';

class MatchLoadingView extends StatelessWidget {
  const MatchLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientContainer(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class MatchErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const MatchErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white70, size: 48),
              const SizedBox(height: 16),
              Text(
                'Could not load match details',
                style: AppTypography.titleLarge.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: Colors.white60),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchPlaceholderView extends StatelessWidget {
  final IconData sportIcon;
  const MatchPlaceholderView({super.key, this.sportIcon = Icons.sports_soccer});

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(sportIcon, color: Colors.white38, size: 64),
            const SizedBox(height: 16),
            Text(
              'Loading match...',
              style: AppTypography.titleLarge.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
