import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../konstanta/warna_aplikasi.dart';

/// 💻 MODE KOMPUTER (Clean Minimalist Theme)
/// Tema dengan desain minimalis dan profesional
/// Cocok untuk penggunaan desktop atau tampilan formal
class ModeKomputer {
  // Mencegah instansiasi class ini
  ModeKomputer._();

  /// Mendapatkan konfigurasi tema komputer lengkap
  static ThemeData get tema {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundComputer,
      primaryColor: AppColors.primaryComputer,
      
      // ─── COLOR SCHEME ───────────────────────────────────────
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryComputer,
        secondary: AppColors.accentComputer,
        surface: AppColors.surfaceComputer,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimaryComputer,
        error: AppColors.failure,
      ),
      
      // ─── TEXT THEME ─────────────────────────────────────────
      // Menggunakan Inter font untuk tampilan profesional
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryComputer,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryComputer,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryComputer,
          letterSpacing: -0.3,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryComputer,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.textPrimaryComputer,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondaryComputer,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textSecondaryComputer,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryComputer,
        ),
      ),
      
      // ─── ELEVATED BUTTON THEME ──────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryComputer,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Lebih kotak
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          elevation: 0,
          shadowColor: AppColors.primaryComputer.withValues(alpha: 0.2),
        ),
      ),
      
      // ─── OUTLINED BUTTON THEME ──────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryComputer,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(
            color: AppColors.surfaceComputerBorder,
            width: 1.5,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // ─── TEXT BUTTON THEME ──────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryComputer,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // ─── CARD THEME ─────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surfaceComputer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.surfaceComputerBorder,
            width: 1,
          ),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8),
      ),
      
      // ─── APP BAR THEME ──────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryComputer,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryComputer,
        ),
      ),
      
      // ─── INPUT DECORATION THEME ─────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceComputerSecond,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.surfaceComputerBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.surfaceComputerBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryComputer,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.failure,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textSecondaryComputer,
          fontSize: 14,
        ),
      ),
      
      // ─── SWITCH THEME ───────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryComputer
              : Colors.grey.shade400,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryComputer.withValues(alpha: 0.3)
              : Colors.grey.shade200,
        ),
      ),
      
      // ─── DIALOG THEME ───────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceComputer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.surfaceComputerBorder,
            width: 1,
          ),
        ),
        elevation: 8,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryComputer,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondaryComputer,
        ),
      ),
      
      // ─── BOTTOM SHEET THEME ─────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceComputer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          side: BorderSide(
            color: AppColors.surfaceComputerBorder,
            width: 1,
          ),
        ),
        elevation: 8,
      ),
      
      // ─── DIVIDER THEME ──────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceComputerBorder,
        thickness: 1,
        space: 1,
      ),
      
      // ─── ICON THEME ─────────────────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryComputer,
        size: 24,
      ),
      
      // ─── FLOATING ACTION BUTTON THEME ───────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryComputer,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // ─── CHIP THEME ─────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceComputerSecond,
        selectedColor: AppColors.primaryComputer,
        disabledColor: Colors.grey.shade200,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryComputer,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: AppColors.surfaceComputerBorder,
            width: 1,
          ),
        ),
      ),
      
      // ─── PROGRESS INDICATOR THEME ───────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryComputer,
        linearTrackColor: AppColors.surfaceComputerSecond,
      ),
      
      // ─── SNACKBAR THEME ─────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimaryComputer,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // ─── DIVIDER COLOR ──────────────────────────────────────
      dividerColor: AppColors.surfaceComputerBorder,
      
      // ─── TOOLTIP THEME ──────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.textPrimaryComputer,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
