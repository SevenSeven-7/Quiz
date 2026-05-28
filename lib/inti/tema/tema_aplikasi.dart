import 'package:flutter/material.dart';
import 'mode_terang.dart';
import 'mode_gelap.dart';
import 'mode_komputer.dart';

/// 🎨 TEMA APLIKASI (Theme Facade)
/// 
/// Class ini berfungsi sebagai facade (pintu gerbang) untuk mengakses
/// semua tema yang tersedia dalam aplikasi.
/// 
/// Setiap mode tema dipisahkan ke file terpisah untuk:
/// - Maintainability: Mudah di-edit tanpa konflik
/// - Scalability: Mudah menambah tema baru
/// - Bug Prevention: Isolasi penuh antar tema
/// - Code Clarity: Setiap file fokus pada satu tema
class AppTheme {
  // Mencegah instansiasi class ini
  AppTheme._();

  /// 🌙 Mendapatkan tema gelap (Dark Blue Neon)
  /// 
  /// Tema dengan nuansa gelap dan aksen biru neon.
  /// Cocok untuk penggunaan di malam hari atau ruangan gelap.
  static ThemeData get darkTheme => ModeGelap.tema;

  /// ☀️ Mendapatkan tema terang (Light Blue)
  /// 
  /// Tema dengan nuansa biru cerah dan latar belakang terang.
  /// Cocok untuk penggunaan di siang hari atau ruangan terang.
  static ThemeData get lightTheme => ModeTerang.tema;

  /// 💻 Mendapatkan tema komputer (Clean Minimalist)
  /// 
  /// Tema dengan desain minimalis dan profesional.
  /// Cocok untuk penggunaan desktop atau tampilan formal.
  static ThemeData get computerTheme => ModeKomputer.tema;
}
