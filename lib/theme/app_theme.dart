import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global design system extracted from Figma design.
/// All colors, typography, and component styles are defined here.
class AppColors {
  AppColors._();

  // Primary - Orange Gradient
  static const Color primaryLight = Color(0xFFFFAA61);
  static const Color primaryDark = Color(0xFFFE7406);
  static const Color primary = Color(0xFFFE7406);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9B9B9B);
  static const Color greyLight = Color(0xFFDDDDDD);
  static const Color greyBackground = Color(0xFFF5F5F5);

  // Glass effect panel
  static const Color glassPanelBackground = Color(0x33DDDDDD); // 20% opacity

  // Status colors
  static const Color available = Color(0xFF4CAF50);
  static const Color booked = Color(0xFFFF5252);

  // Card backgrounds
  static const Color cardBackground = Color(0xFFF8F8F8);
  static const Color cardBorder = Color(0xFFE0E0E0);

  // Calendar
  static const Color calendarWeekend = Color(0xFF9B9B9B);
  static const Color calendarActive = Color(0xFF000000);
  static const Color calendarInactive = Color(0xFFBDBDBD);
  static const Color calendarHighlight = Color(0xFFFE7406);

  // Divider
  static const Color divider = Color(0xFFE0E0E0);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryLight, primaryDark],
  );
}

class AppTypography {
  AppTypography._();

  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 66,
        fontWeight: FontWeight.w300,
        color: AppColors.black,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 41,
        fontWeight: FontWeight.w300,
        color: AppColors.grey,
      );

  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  static TextStyle get headlineSmall => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: AppColors.black,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.grey,
      );

  static TextStyle get labelLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.white,
      );

  static TextStyle get labelMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  static TextStyle get labelSmall => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.grey,
      );
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;
}

class AppRadius {
  AppRadius._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 33.0; // Book Now button
  static const double circular = 100.0;
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.white,
        error: AppColors.booked,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xxl),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.greyBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.grey),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        elevation: 0,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }
}
