import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum tiga mode tema khusus - bukan lagi ThemeMode Flutter
enum AppThemeMode { dark, light, computer }

// Provider untuk mode tema aplikasi
final temaProvider = StateNotifierProvider<TemaNotifier, AppThemeMode>((ref) {
  return TemaNotifier();
});

// Notifier yang mengelola perubahan tema dan menyimpannya ke SharedPreferences
class TemaNotifier extends StateNotifier<AppThemeMode> {
  TemaNotifier() : super(AppThemeMode.computer) {
    _muatTema();
  }

  // Memuat preferensi tema dari penyimpanan lokal
  Future<void> _muatTema() async {
    final prefs = await SharedPreferences.getInstance();
    final temaStr = prefs.getString('mode_tema') ?? 'computer';

    switch (temaStr) {
      case 'dark':
        state = AppThemeMode.dark;
        break;
      case 'light':
        state = AppThemeMode.light;
        break;
      default:
        state = AppThemeMode.computer;
    }
  }

  // Mengubah mode tema dan menyimpannya secara permanen
  Future<void> ubahTema(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String temaStr;
    switch (mode) {
      case AppThemeMode.dark:
        temaStr = 'dark';
        break;
      case AppThemeMode.light:
        temaStr = 'light';
        break;
      case AppThemeMode.computer:
        temaStr = 'computer';
        break;
    }
    await prefs.setString('mode_tema', temaStr);
    state = mode;
  }
}
