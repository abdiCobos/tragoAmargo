import 'package:flutter/material.dart';

class AppColors {
  static const Color brown900 = Color(0xFF3E2723);
  static const Color brown800 = Color(0xFF4E342E);
  static const Color brown700 = Color(0xFF5D4037);
  static const Color brown600 = Color(0xFF6D4C41);
  static const Color brown200 = Color(0xFFBCAAA4);
  static const Color brown100 = Color(0xFFD7CCC8);
  static const Color brown50 = Color(0xFFEFEBE9);
  static const Color cream = Color(0xFFFFF8E1);
  static const Color gold = Color(0xFFC8A96E);
  static const Color goldLight = Color(0xFFE8D5B0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color error = Color(0xFFC62828);
  static const Color success = Color(0xFF2E7D32);

  static const Color primary = brown800;
  static const Color secondary = gold;
  static const Color tertiary = brown200;
  static const Color surface = brown50;
  static const Color background = white;
  static const Color onPrimary = white;
  static const Color onSecondary = white;
  static const Color star = gold;
  static const Color textPrimary = black;
  static const Color textSecondary = gray600;
  static const Color divider = gray200;
}

class AppTheme {
  static const _bodyFont = 'Inter';
  static const _displayFont = 'PlayfairDisplay';

  static const _textTheme = TextTheme(
    bodyLarge: TextStyle(fontFamily: _bodyFont, fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontFamily: _bodyFont, fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontFamily: _bodyFont, fontSize: 12, fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontFamily: _displayFont, fontSize: 22, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontFamily: _bodyFont, fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontFamily: _bodyFont, fontSize: 14, fontWeight: FontWeight.w600),
    headlineLarge: TextStyle(fontFamily: _displayFont, fontSize: 32, fontWeight: FontWeight.w900),
    headlineMedium: TextStyle(fontFamily: _displayFont, fontSize: 28, fontWeight: FontWeight.w700),
    headlineSmall: TextStyle(fontFamily: _displayFont, fontSize: 24, fontWeight: FontWeight.w700),
    labelLarge: TextStyle(fontFamily: _bodyFont, fontSize: 14, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontFamily: _bodyFont, fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontFamily: _bodyFont, fontSize: 11, fontWeight: FontWeight.w500),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.brown800,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.brown700,
        onPrimaryContainer: AppColors.goldLight,
        secondary: AppColors.gold,
        onSecondary: AppColors.brown900,
        secondaryContainer: AppColors.goldLight,
        onSecondaryContainer: AppColors.brown900,
        tertiary: AppColors.brown600,
        onTertiary: AppColors.white,
        surface: AppColors.brown50,
        onSurface: AppColors.black,
        surfaceContainerHighest: AppColors.cream,
        onSurfaceVariant: AppColors.gray600,
        outline: AppColors.brown200,
        outlineVariant: AppColors.brown100,
        error: AppColors.error,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: _textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.brown800,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.brown800,
        foregroundColor: AppColors.white,
        elevation: 2,
        centerTitle: true,
        scrolledUnderElevation: 4,
        shadowColor: AppColors.brown900,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: _displayFont,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        iconTheme: IconThemeData(color: AppColors.goldLight),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.brown800,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.brown200,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.brown900,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: AppColors.brown900.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        color: AppColors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.brown100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.brown100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brown800,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 4,
          shadowColor: AppColors.brown900.withValues(alpha: 0.30),
          textStyle: const TextStyle(
            fontFamily: _bodyFont,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brown700,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: const BorderSide(color: AppColors.brown200, width: 2),
          textStyle: const TextStyle(
            fontFamily: _bodyFont,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brown700,
          textStyle: const TextStyle(
            fontFamily: _bodyFont,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.brown50,
        selectedColor: AppColors.gold.withValues(alpha: 0.25),
        labelStyle: const TextStyle(
          fontFamily: _bodyFont,
          fontSize: 13,
          color: AppColors.brown700,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: _bodyFont,
          fontSize: 13,
          color: AppColors.brown800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: AppColors.brown100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: _displayFont,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.brown800,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: _bodyFont,
          fontSize: 15,
          color: AppColors.textSecondary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.brown800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentTextStyle: const TextStyle(
          fontFamily: _bodyFont,
          fontSize: 14,
          color: AppColors.white,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.brown100,
        thickness: 1,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.gold,
        unselectedLabelColor: AppColors.brown200,
        indicatorColor: AppColors.gold,
      ),
    );
  }
}
