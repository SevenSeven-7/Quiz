import 'package:flutter/material.dart';

// Kelas AppColors menyimpan definisi palet warna neon premium yang digunakan di seluruh aplikasi.
class AppColors {
  // Warna latar belakang utama (hitam keunguan yang sangat dalam)
  static const Color background = Color(0xFF050510);

  // Warna permukaan untuk kartu dan kontainer (biru gelap glassmorphism)
  static const Color surface = Color(0xFF0F0F2D);

  // Warna permukaan lebih terang untuk elemen sekunder
  static const Color surfaceLight = Color(0xFF1A1A40);

  // Warna utama/aksen aplikasi (ungu neon)
  static const Color primary = Color(0xFF7C3AED);

  // Warna aksen kedua (cyan neon)
  static const Color accent = Color(0xFF06B6D4);

  // Warna primer lebih terang untuk gradien
  static const Color primaryLight = Color(0xFFA855F7);

  // Warna emas untuk bintang dan prestasi
  static const Color gold = Color(0xFFF59E0B);

  // Warna untuk indikasi jawaban benar atau sukses (hijau emerald)
  static const Color success = Color(0xFF10B981);

  // Warna untuk indikasi jawaban salah atau kegagalan (merah terang)
  static const Color failure = Color(0xFFEF4444);

  // Warna teks utama (putih)
  static const Color textPrimary = Colors.white;

  // Warna teks sekunder (abu-abu terang)
  static const Color textSecondary = Color(0xFF94A3B8);

  // Gradien utama ungu → cyan
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradien ungu → ungu terang untuk tombol
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradien latar belakang gelap
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF050510), Color(0xFF0A0A25), Color(0xFF050510)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Efek glow neon ungu untuk shadow
  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: const Color(0xFF7C3AED).withOpacity(0.4),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  // Efek glow cyan untuk shadow
  static List<BoxShadow> accentGlow = [
    BoxShadow(
      color: const Color(0xFF06B6D4).withOpacity(0.4),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
}
