import 'package:flutter/material.dart';

// Kelas AppColors - Palet warna tunggal profesional (Modern Premium Light)
class AppColors {
  // ─── TEMA MODERN PREMIUM LIGHT ─────────────────────────────────
  // Latar belakang bersih dan cerah (Slate 50)
  static const Color background     = Color(0xFFF8FAFC); 
  
  // Permukaan kartu (Putih murni dengan efek elegan)
  static const Color surface        = Color(0xFFFFFFFF); 
  static const Color surfaceLight   = Color(0xFFF1F5F9); 
  
  // Warna Utama (Royal Blue / Sky Blue - Sangat elegan untuk aplikasi edukasi/kuis)
  static const Color primary        = Color(0xFF2563EB); // Blue 600
  static const Color primaryLight   = Color(0xFF3B82F6); // Blue 500
  static const Color accent         = Color(0xFF0EA5E9); // Sky 500
  
  // Warna Status Kuis
  static const Color gold           = Color(0xFFF59E0B); // Amber 500 (Gelar/Bintang)
  static const Color success        = Color(0xFF10B981); // Emerald 500 (Benar)
  static const Color failure        = Color(0xFFF43F5E); // Rose 500 (Salah)
  
  // Teks
  static const Color textPrimary    = Color(0xFF0F172A); // Slate 900 (Gelap pekat)
  static const Color textSecondary  = Color(0xFF64748B); // Slate 500 (Abu-abu kebiruan)

  // ─── GRADIEN TEMA ───────────────────────────────────
  // Gradien untuk tombol/header (Blue ke Sky)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradien latar belakang (Sangat halus)
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFEEF2F6), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── GRADIEN RANK / GELAR ──────────────────────────────────────────
  static const LinearGradient bronzeGradient = LinearGradient(
    colors: [Color(0xFFE7A675), Color(0xFFB06431)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  
  static const LinearGradient silverGradient = LinearGradient(
    colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFDE68A), Color(0xFFD97706)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  
  static const LinearGradient legendGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFE81CFF), Color(0xFF40C9FF)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  // ─── SHADOW & GLOW ───────────────────────────────────────────────
  // Shadow lembut elegan untuk kartu kuis
  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: const Color(0xFF2563EB).withValues(alpha: 0.2),
      blurRadius: 16,
      spreadRadius: 2,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];
}
