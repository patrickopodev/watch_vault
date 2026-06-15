import 'dart:ui';

class ThemeColors {
  ThemeColors._();

  static const background = Color(0xFF0A0A0F);
  static const surface = Color(0xFF13131A);
  static const surfaceElevated = Color(0xFF1C1C26);
  static const border = Color(0xFF2A2A3D);

  static const primary = Color(0xFF7C3AED);
  static const primaryLight = Color(0xFFA78BFA);
  static const secondary = Color(0xFF06B6D4);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);

  static const textPrimary = Color(0xFFF8F8FF);
  static const textSecondary = Color(0xFF9090A0);
  static const textMuted = Color(0xFF50505F);
}

class ThemeSpacing {
  ThemeSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
  static const double massive = 64;

  static const double borderRadiusXs = 6;
  static const double borderRadiusSm = 10;
  static const double borderRadiusMd = 14;
  static const double borderRadiusLg = 20;
  static const double borderRadiusXl = 28;
}

class ThemeTypography {
  ThemeTypography._();

  static const double displayLargeSize = 32;
  static const FontWeight displayLargeWeight = FontWeight.w800;
  static const double displayLargeLetterSpacing = -0.5;

  static const double displayMediumSize = 24;
  static const FontWeight displayMediumWeight = FontWeight.w700;

  static const double titleLargeSize = 20;
  static const FontWeight titleLargeWeight = FontWeight.w700;

  static const double titleMediumSize = 17;
  static const FontWeight titleMediumWeight = FontWeight.w600;

  static const double bodyLargeSize = 15;
  static const FontWeight bodyLargeWeight = FontWeight.w400;

  static const double bodyMediumSize = 13;
  static const FontWeight bodyMediumWeight = FontWeight.w400;

  static const double labelLargeSize = 12;
  static const FontWeight labelLargeWeight = FontWeight.w600;
  static const double labelLargeLetterSpacing = 0.5;

  static const double labelSmallSize = 10;
  static const FontWeight labelSmallWeight = FontWeight.w500;
  static const double labelSmallLetterSpacing = 0.8;
}
