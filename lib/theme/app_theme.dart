/// Material 3 Theme Configuration
/// Custom theme with gold gradient brand colors and semantic colors
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Colors - Design System Tokens
class AppColors {
  AppColors._();

  // Base colors
  static const cream = Color(0xFFFFFFF6);

  // Brand colors (Gold gradient)
  static const brandDark = Color(0xFF9B631C);
  static const brandLight = Color(0xFFE3BD63);

  // Interactive scale (grays and blacks)
  static const interactive500 = Color(0xFF000000); // Black - primary text
  static const interactive400 = Color(0xFF333333); // Dark gray - secondary
  static const interactive300 = Color(0xFF666666); // Medium gray - tertiary
  static const interactive200 = Color(0xFFB3B3B3); // Light gray - placeholders
  static const interactive100 = Color(0xFFE0E0E0); // Very light gray - borders
  static const interactive50 = Color(0xFFF5F5F5); // Very light gray - backgrounds

  // Semantic colors (proper semantic colors)
  static const error = Color(0xFFEF4444); // Red for errors
  static const success = Color(0xFF10B981); // Green for success
  static const warning = Color(0xFFF59E0B); // Amber for warnings
  static const info = Color(0xFF3B82F6); // Blue for info/focus

  // Focus state
  static const focus = Color(0xFF3B82F6); // Blue for focus

  // Icon colors
  static const iconOnBrand = Color(0xFFFFFFFF); // White on gradient

  /// Brand gradient (gold)
  static const brandGradient = LinearGradient(
    colors: [brandDark, brandLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

/// App Spacing - 4px base grid
class AppSpacing {
  AppSpacing._();

  static const double x0 = 0;
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x14 = 56;
}

/// App Radius
class AppRadius {
  AppRadius._();

  static const double small = 4;
  static const double medium = 8;
  static const double large = 16;
  static const double round = 999; // Circular
}

/// Material 3 Theme
class AppTheme {
  AppTheme._();

  /// Light theme (primary theme for the app)
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.brandDark,
      secondary: AppColors.brandLight,
      error: AppColors.error,
      surface: AppColors.cream,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.interactive500,
      onError: Colors.white,
      outline: AppColors.interactive200,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.cream,

      // Typography
      textTheme: _buildTextTheme(),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(
            color: AppColors.interactive200,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(
            color: AppColors.interactive200,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(
            color: AppColors.focus,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        hintStyle: const TextStyle(
          color: AppColors.interactive200,
          fontSize: 16,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x5,
            vertical: AppSpacing.x3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.25),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        side: const BorderSide(
          color: AppColors.interactive200,
          width: 2,
        ),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.success;
          }
          return Colors.white;
        }),
      ),
    );
  }

  /// Build custom text theme with Inter and Playfair Display
  static TextTheme _buildTextTheme() {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return baseTextTheme.copyWith(
      // Heading - Playfair Display Bold 28px
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.14, // 32px line height
        color: AppColors.interactive500,
      ),

      // Paragraph Large - Inter Regular 16px
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5, // 24px line height
        color: AppColors.interactive400,
      ),

      // Paragraph Medium - Inter Regular 14px
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43, // 20px line height
        color: AppColors.interactive400,
      ),

      // Paragraph Small - Inter Regular 12px
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5, // 18px line height
        color: AppColors.interactive300,
      ),

      // Button Text - Inter SemiBold 16px
      labelLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),

      // Medium Text - Inter Medium
      labelMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
      ),
    );
  }
}

/// Common shadows
class AppShadows {
  AppShadows._();

  static const defaultShadow = [
    BoxShadow(
      color: Color(0x40000000), // 25% opacity black
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  static const pressedShadow = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
  ];
}
