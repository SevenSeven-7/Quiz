import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../konstanta/warna_aplikasi.dart';

/// ☀️ MODE TERANG (Light Blue Theme)
/// Tema dengan nuansa biru cerah dan latar belakang terang
/// Cocok untuk penggunaan di siang hari atau ruangan terang
class ModeTerang {
  // Mencegah instansiasi class ini
  ModeTerang._();

  /// Mendapatkan konfigurasi tema terang lengkap
  static ThemeData get tema {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLightBlue,
      primaryColor: AppColors.primary,
      
      // ─── COLOR SCHEME ───────────────────────────────────────
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surfaceLightBlue,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimaryLightBlue,
      ),
      
      // ─── TEXT THEME ─────────────────────────────────────────
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLightBlue,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLightBlue,
        ),
        displaySmall: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLightBlue,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLightBlue,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          color: AppColors.textPrimaryLightBlue,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          color: AppColors.textSecondaryLightBlue,
        ),
        bodySmall: GoogleFonts.outfit(
          fontSize: 12,
          color: AppColors.textSecondaryLightBlue,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLightBlue,
        ),
      ),
      
      // ─── ELEVATED BUTTON THEME ──────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      
      // ─── OUTLINED BUTTON THEME ──────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // ─── TEXT BUTTON THEME ──────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // ─── CARD THEME ─────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surfaceLightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
        margin: const EdgeInsets.all(8),
      ),
      
      // ─── APP BAR THEME ──────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLightBlue,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryLightBlue,
        ),
      ),
      
      // ─── INPUT DECORATION THEME ─────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLightModeSecond.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.failure,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.outfit(
          color: AppColors.textSecondaryLightBlue,
          fontSize: 14,
        ),
      ),
      
      // ─── SWITCH THEME ───────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.grey,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.black12,
        ),
      ),
      
      // ─── DIALOG THEME ───────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLightBlue,
        ),
        contentTextStyle: GoogleFonts.outfit(
          fontSize: 14,
          color: AppColors.textSecondaryLightBlue,
        ),
      ),
      
      // ─── BOTTOM SHEET THEME ─────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        elevation: 8,
      ),
      
      // ─── DIVIDER THEME ──────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: Color(0x12000000),
        thickness: 1,
        space: 1,
      ),
      
      // ─── ICON THEME ─────────────────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryLightBlue,
        size: 24,
      ),
      
      // ─── FLOATING ACTION BUTTON THEME ───────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // ─── CHIP THEME ─────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceLightModeSecond,
        selectedColor: AppColors.primary,
        disabledColor: Colors.grey.shade300,
        labelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // ─── PROGRESS INDICATOR THEME ───────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceLightModeSecond,
      ),
      
      // ─── SNACKBAR THEME ─────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimaryLightBlue,
        contentTextStyle: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // ─── DIVIDER COLOR ──────────────────────────────────────
      dividerColor: Colors.black.withValues(alpha: 0.07),
    );
  }
}
