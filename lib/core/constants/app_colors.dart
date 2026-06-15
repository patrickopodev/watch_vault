import 'package:flutter/painting.dart';
import '../theme/theme_data.dart';

class AppColors {
  AppColors._();

  static const Color background = ThemeColors.background;
  static const Color surface = ThemeColors.surface;
  static const Color surfaceElevated = ThemeColors.surfaceElevated;
  static const Color border = ThemeColors.border;

  static const Color primary = ThemeColors.primary;
  static const Color primaryLight = ThemeColors.primaryLight;
  static const Color secondary = ThemeColors.secondary;
  static const Color success = ThemeColors.success;
  static const Color warning = ThemeColors.warning;
  static const Color danger = ThemeColors.danger;

  static const Color textPrimary = ThemeColors.textPrimary;
  static const Color textSecondary = ThemeColors.textSecondary;
  static const Color textMuted = ThemeColors.textMuted;

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const liveGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    tileMode: TileMode.clamp,
  );
}
