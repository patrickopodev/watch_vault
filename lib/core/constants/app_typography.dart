import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme_data.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: ThemeTypography.displayLargeSize,
        fontWeight: ThemeTypography.displayLargeWeight,
        letterSpacing: ThemeTypography.displayLargeLetterSpacing,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: ThemeTypography.displayMediumSize,
        fontWeight: ThemeTypography.displayMediumWeight,
      );

  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: ThemeTypography.titleLargeSize,
        fontWeight: ThemeTypography.titleLargeWeight,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: ThemeTypography.titleMediumSize,
        fontWeight: ThemeTypography.titleMediumWeight,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: ThemeTypography.bodyLargeSize,
        fontWeight: ThemeTypography.bodyLargeWeight,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: ThemeTypography.bodyMediumSize,
        fontWeight: ThemeTypography.bodyMediumWeight,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: ThemeTypography.labelLargeSize,
        fontWeight: ThemeTypography.labelLargeWeight,
        letterSpacing: ThemeTypography.labelLargeLetterSpacing,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: ThemeTypography.labelSmallSize,
        fontWeight: ThemeTypography.labelSmallWeight,
        letterSpacing: ThemeTypography.labelSmallLetterSpacing,
      );
}
