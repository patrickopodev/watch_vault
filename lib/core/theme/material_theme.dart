import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_data.dart';

class MaterialTheme {
  MaterialTheme._();

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ThemeColors.background,
      colorScheme: const ColorScheme.dark(
        primary: ThemeColors.primary,
        secondary: ThemeColors.secondary,
        surface: ThemeColors.surface,
        error: ThemeColors.danger,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: ThemeTypography.displayLargeSize,
          fontWeight: ThemeTypography.displayLargeWeight,
          letterSpacing: ThemeTypography.displayLargeLetterSpacing,
          color: ThemeColors.textPrimary,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: ThemeTypography.displayMediumSize,
          fontWeight: ThemeTypography.displayMediumWeight,
          color: ThemeColors.textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: ThemeTypography.titleLargeSize,
          fontWeight: ThemeTypography.titleLargeWeight,
          color: ThemeColors.textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: ThemeTypography.titleMediumSize,
          fontWeight: ThemeTypography.titleMediumWeight,
          color: ThemeColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: ThemeTypography.bodyLargeSize,
          fontWeight: ThemeTypography.bodyLargeWeight,
          color: ThemeColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: ThemeTypography.bodyMediumSize,
          fontWeight: ThemeTypography.bodyMediumWeight,
          color: ThemeColors.textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: ThemeTypography.labelLargeSize,
          fontWeight: ThemeTypography.labelLargeWeight,
          letterSpacing: ThemeTypography.labelLargeLetterSpacing,
          color: ThemeColors.textSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: ThemeTypography.labelSmallSize,
          fontWeight: ThemeTypography.labelSmallWeight,
          letterSpacing: ThemeTypography.labelSmallLetterSpacing,
          color: ThemeColors.textMuted,
        ),
      ),
      cardTheme: CardThemeData(
        color: ThemeColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeSpacing.borderRadiusMd),
          side: const BorderSide(color: ThemeColors.border),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ThemeColors.surface,
        selectedItemColor: ThemeColors.primary,
        unselectedItemColor: ThemeColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThemeColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeSpacing.borderRadiusXs),
          borderSide: const BorderSide(color: ThemeColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeSpacing.borderRadiusXs),
          borderSide: const BorderSide(color: ThemeColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeSpacing.borderRadiusXs),
          borderSide: const BorderSide(color: ThemeColors.primary),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: ThemeTypography.bodyMediumSize,
          fontWeight: ThemeTypography.bodyMediumWeight,
          color: ThemeColors.textMuted,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeSpacing.borderRadiusSm),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: ThemeTypography.labelLargeSize,
            fontWeight: FontWeight.w700,
            letterSpacing: ThemeTypography.labelLargeLetterSpacing,
          ),
        ),
      ),
    );
  }
}
