import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ------------------------------------------------------------
  // LIGHT THEME
  // ------------------------------------------------------------

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryOrange,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: const Color(0xFFF8F8F8),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF212121),
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    inputDecorationTheme: _inputDecoration(
      fillColor: Colors.white,
      borderColor: Color(0xFFE0E0E0),
      focusedColor: AppColors.primaryOrange,
    ),

    elevatedButtonTheme: _buttonTheme(
      backgroundColor: AppColors.primaryOrange,
    ),
  );

  // ------------------------------------------------------------
  // DARK THEME
  // ------------------------------------------------------------

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryOrange,
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: const Color(0xFF121212),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    inputDecorationTheme: _inputDecoration(
      fillColor: const Color(0xFF1E1E1E),
      borderColor: const Color(0xFF424242),
      focusedColor: AppColors.primaryOrange,
    ),

    elevatedButtonTheme: _buttonTheme(
      backgroundColor: AppColors.primaryOrange,
    ),
  );

  // ------------------------------------------------------------
  // ORANGE THEME
  // ------------------------------------------------------------

  static ThemeData orangeTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryOrange,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: const Color(0xFFFFF7ED),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryOrange,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    inputDecorationTheme: _inputDecoration(
      fillColor: Colors.white,
      borderColor: const Color(0xFFFFCC80),
      focusedColor: AppColors.primaryOrange,
    ),

    elevatedButtonTheme: _buttonTheme(
      backgroundColor: AppColors.primaryOrangeDark,
    ),
  );
  static ThemeData redTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryOrange,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: const Color(0xFFFFF7ED),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryOrange,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    inputDecorationTheme: _inputDecoration(
      fillColor: Colors.white,
      borderColor: const Color(0xFFFFCC80),
      focusedColor: AppColors.primaryOrange,
    ),

    elevatedButtonTheme: _buttonTheme(
      backgroundColor: AppColors.primaryOrangeDark,
    ),
  );

  // ------------------------------------------------------------
  // COMMON INPUT DECORATION
  // ------------------------------------------------------------

  static InputDecorationTheme _inputDecoration({
    required Color fillColor,
    required Color borderColor,
    required Color focusedColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: focusedColor,
          width: 2,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BUTTON
  // ------------------------------------------------------------

  static ElevatedButtonThemeData _buttonTheme({
    required Color backgroundColor,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,

        minimumSize: const Size(
          double.infinity,
          50,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
