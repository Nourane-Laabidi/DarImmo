import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'store.dart';

class Ui {
  static bool get dark => AppStore.instance.dark;
  static Color get bg => dark ? const Color(0xFF0F172A) : AppColors.bg;
  static Color get card => dark ? const Color(0xFF1E293B) : Colors.white;
  static Color get ink => dark ? Colors.white : AppColors.text;
  static Color get mute => dark ? const Color(0xFF94A3B8) : AppColors.muted;
  static Color get line => dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
}

class AppColors {
  static const primary = Color(0xFF1E3A8A);
  static const teal = Color(0xFF0F766E);
  static const price = Color(0xFFC2410C);
  static const bg = Color(0xFFF8FAFC);
  static const text = Color(0xFF0F172A);
  static const muted = Color(0xFF475569);
  static const border = Color(0xFFCBD5E1);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    scaffoldBackgroundColor: AppColors.bg,
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
  );
}