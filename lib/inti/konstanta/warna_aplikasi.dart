import 'package:flutter/material.dart';

// Kelas AppColors - Palet warna untuk TIGA tema: Gelap Biru, Terang Biru, Komputer Putih
class AppColors {
  // ─── TEMA GELAP (Dark Blue Neon) ─────────────────────────────────
  static const Color background     = Color(0xFF0B132B); // Lebih elegan, navy gelap
  static const Color surface        = Color(0xFF14213D); // Biru tua layer 1
  static const Color surfaceLight   = Color(0xFF1C2F59); // Biru tua layer 2
  static const Color primary        = Color(0xFF1E90FF); // Biru neon terang
  static const Color accent         = Color(0xFF00D4FF); // Cyan neon
  static const Color primaryLight   = Color(0xFF60B8FF); // Biru neon muda
  static const Color gold           = Color(0xFFF59E0B);
  static const Color success        = Color(0xFF10B981);
  static const Color failure        = Color(0xFFEF4444);
  static const Color textPrimary    = Colors.white;
  static const Color textSecondary  = Color(0xFF7FA8CC);

  // ─── TEMA TERANG (Light Blue Neon) ────────────────────────────────
  static const Color backgroundLightBlue     = Color(0xFFF1F5F9); // Slate 50 elegan
  static const Color surfaceLightBlue        = Color(0xFFFFFFFF);
  static const Color surfaceLightBlueSecond  = Color(0xFFE2E8F0); // Slate 200
  static const Color textPrimaryLightBlue    = Color(0xFF0F172A); // Slate 900
  static const Color textSecondaryLightBlue  = Color(0xFF334155); // Slate 700

  // ─── TEMA KOMPUTER (Clean White & Gray - Minimalis Desktop) ─────────────
  static const Color backgroundComputer      = Color(0xFFF0F0F0); // Abu sangat terang
  static const Color surfaceComputer         = Color(0xFFFFFFFF); // Putih bersih
  static const Color surfaceComputerSecond   = Color(0xFFE0E0E0); // Abu sedang untuk hover/pilihan
  static const Color surfaceComputerBorder   = Color(0xFFCCCCCC); // Abu batas/border
  static const Color primaryComputer         = Color(0xFF333333); // Abu gelap (hampir hitam)
  static const Color primaryComputerLight    = Color(0xFF555555); // Abu sedang gelap
  static const Color accentComputer          = Color(0xFF666666); // Abu aksen
  static const Color textPrimaryComputer     = Color(0xFF111111); // Hitam untuk teks
  static const Color textSecondaryComputer   = Color(0xFF666666); // Abu-abu teks sekunder

  // ─── GRADIEN TEMA GELAP (Biru) ───────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E90FF), Color(0xFF00D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF1E90FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0B132B), Color(0xFF14213D), Color(0xFF0B132B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── GRADIEN TEMA TERANG BIRU ─────────────────────────────────────
  static const LinearGradient backgroundLightGradient = LinearGradient(
    colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0), Color(0xFFF1F5F9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryLightGradient = LinearGradient(
    colors: [Color(0xFF1E90FF), Color(0xFF00D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── GRADIEN TEMA KOMPUTER (Abu-abu/Putih Solid & Flat) ────────────
  static const LinearGradient primaryComputerGradient = LinearGradient(
    colors: [Color(0xFF555555), Color(0xFF333333)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundComputerGradient = LinearGradient(
    colors: [Color(0xFFF0F0F0), Color(0xFFE8E8E8), Color(0xFFF0F0F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── SHADOW & GLOW ───────────────────────────────────────────────
  // Neon glow untuk tema Gelap Biru
  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: const Color(0xFF1E90FF).withValues(alpha: 0.45),
      blurRadius: 24,
      spreadRadius: 3,
    ),
  ];

  // Glow untuk tema Terang Biru
  static List<BoxShadow> lightBlueGlow = [
    BoxShadow(
      color: const Color(0xFF1E90FF).withValues(alpha: 0.28),
      blurRadius: 16,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> computerShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 10,
      offset: const Offset(0, 4),
    )
  ];

  // Shadow card untuk komputer
  static List<BoxShadow> computerCardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 3),
    ),
  ];

  // Alias lama (agar tidak ada file lain yang error)
  static const Color backgroundLight       = backgroundLightBlue;
  static const Color surfaceLightMode      = surfaceLightBlue;
  static const Color surfaceLightModeSecond = surfaceLightBlueSecond;
  static const Color textPrimaryLight      = textPrimaryLightBlue;
  static const Color textSecondaryLight    = textSecondaryLightBlue;
  static List<BoxShadow> get lightShadow   => lightBlueGlow;
  static List<BoxShadow> get accentGlow    => primaryGlow;
}
