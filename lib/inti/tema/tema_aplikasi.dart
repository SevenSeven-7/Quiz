import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../konstanta/warna_aplikasi.dart';

class AppTheme {
  // ─── TEMA GELAP (Dark Blue Neon) ──────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        bodyLarge:    GoogleFonts.outfit(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        bodyMedium:   GoogleFonts.outfit(fontSize: 14, color: AppColors.textSecondary),
        bodySmall:    GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.primary : Colors.white54),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.primary.withValues(alpha: 0.4) : Colors.white12),
      ),
      dividerColor: Colors.white10,
    );
  }

  // ─── TEMA TERANG (Light Blue Neon) ────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLightBlue,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surfaceLightBlue,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimaryLightBlue,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLightBlue),
        bodyLarge:    GoogleFonts.outfit(fontSize: 16, color: AppColors.textPrimaryLightBlue, fontWeight: FontWeight.w500),
        bodyMedium:   GoogleFonts.outfit(fontSize: 14, color: AppColors.textSecondaryLightBlue),
        bodySmall:    GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondaryLightBlue),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLightBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLightBlue),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLightBlue),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.primary : Colors.grey),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.primary.withValues(alpha: 0.3) : Colors.black12),
      ),
      dividerColor: Colors.black.withValues(alpha: 0.07),
    );
  }

  // ─── TEMA KOMPUTER (Clean White - Desktop Minimalis) ──────────────
  static ThemeData get computerTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundComputer,
      primaryColor: AppColors.primaryComputer,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryComputer,
        secondary: AppColors.accentComputer,
        surface: AppColors.surfaceComputer,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimaryComputer,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimaryComputer),
        bodyLarge:    GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimaryComputer, fontWeight: FontWeight.w500),
        bodyMedium:   GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondaryComputer),
        bodySmall:    GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryComputer),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryComputer,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceComputer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.surfaceComputerBorder, width: 1),
        ),
        elevation: 0,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimaryComputer),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryComputer),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.primaryComputer : Colors.grey.shade400),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.primaryComputer.withValues(alpha: 0.3) : Colors.grey.shade200),
      ),
      dividerColor: AppColors.surfaceComputerBorder,
    );
  }
}
