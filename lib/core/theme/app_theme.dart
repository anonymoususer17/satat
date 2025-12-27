import 'package:flutter/material.dart';

/// App theme inspired by Balatro - elegant, simple, with good visual hierarchy
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color Palette - Elegant and simple
  static const Color primaryColor = Color(0xFF6C5CE7); // Purple
  static const Color secondaryColor = Color(0xFFFD79A8); // Pink
  static const Color accentColor = Color(0xFF00B894); // Green
  static const Color errorColor = Color(0xFFD63031); // Red

  static const Color backgroundColor = Color(0xFF2D3436); // Dark gray
  static const Color surfaceColor = Color(0xFF636E72); // Medium gray
  static const Color cardColor = Color(0xFFDFE6E9); // Light gray

  // Card Suit Colors
  static const Color heartsColor = Color(0xFFD63031); // Red
  static const Color diamondsColor = Color(0xFFE17055); // Orange-red
  static const Color clubsColor = Color(0xFF2D3436); // Black
  static const Color spadesColor = Color(0xFF2D3436); // Black

  // Text Colors
  static const Color textPrimaryColor = Color(0xFFDFE6E9); // Light
  static const Color textSecondaryColor = Color(0xFFB2BEC3); // Gray
  static const Color textOnCardColor = Color(0xFF2D3436); // Dark

  // Game-specific Colors
  static const Color trumpIndicatorColor = Color(0xFFFDCB6E); // Gold
  static const Color currentTurnColor = Color(0xFF00B894); // Green
  static const Color winnerColor = Color(0xFFFDCB6E); // Gold

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2D3436),
      Color(0xFF636E72),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFDFE6E9),
    ],
  );

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Card Animation Durations
  static const Duration cardDealDuration = Duration(milliseconds: 300);
  static const Duration cardPlayDuration = Duration(milliseconds: 400);
  static const Duration trickCollectDuration = Duration(milliseconds: 500);

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double cardBorderRadius = 8.0;

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Card Dimensions
  static const double cardWidth = 80.0;
  static const double cardHeight = 112.0;
  static const double cardAspectRatio = cardWidth / cardHeight;

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textPrimaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLarge,
          vertical: spacingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingSmall,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingMedium,
        vertical: spacingMedium,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
    ),
  );

  // Dark Theme (same as light theme for now, can customize later)
  static ThemeData darkTheme = lightTheme;
}
