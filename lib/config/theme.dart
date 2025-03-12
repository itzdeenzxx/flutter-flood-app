import 'package:flutter/material.dart';
import 'dark_theme_colors.dart';

class AppTheme {
  // Light Theme colors (unchanged)
  static const Color primaryColor = Color(0xFF4865E7);
  static const Color secondaryColor = Color(0xFFFF6B6B);
  static const Color tertiaryColor = Color(0xFF42B9A0);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1E293B);
  static const Color lightTextColor = Color(0xFF64748B);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Prompt',
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      background: backgroundColor,
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Prompt',
      ),
      iconTheme: IconThemeData(color: textColor),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
    ),
  );

  // Dark Theme using colors from DarkThemeColors with improved contrast
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: DarkThemeColors.primary,
    scaffoldBackgroundColor: DarkThemeColors.background,
    fontFamily: 'Prompt',
    colorScheme: ColorScheme.dark(
      primary: DarkThemeColors.primary,
      secondary: DarkThemeColors.secondary,
      tertiary: DarkThemeColors.tertiary,
      background: DarkThemeColors.background,
      surface: DarkThemeColors.card,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    cardTheme: CardTheme(
      color: DarkThemeColors.card,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: DarkThemeColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Prompt',
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white70),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.white70),
      labelStyle: TextStyle(color: Colors.white70),
    ),
  );
}
