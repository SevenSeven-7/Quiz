import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'inti/tema/tema_aplikasi.dart';
import 'inti/penyedia/penyedia_tema.dart';
import 'fitur/splash/layar_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Mengaktifkan mode layar penuh (Immersive Mode) agar navigasi HP disembunyikan
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Jalankan aplikasi
  runApp(
    const ProviderScope(
      child: QuizApp(),
    ),
  );
}

// Widget utama yang merespons perubahan tema secara real-time
class QuizApp extends ConsumerWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(temaProvider);

    // Pilih ThemeData berdasarkan mode yang aktif
    ThemeData selectedTheme;
    switch (appThemeMode) {
      case AppThemeMode.dark:
        selectedTheme = AppTheme.darkTheme;
        break;
      case AppThemeMode.light:
        selectedTheme = AppTheme.lightTheme;
        break;
      case AppThemeMode.computer:
        selectedTheme = AppTheme.computerTheme;
        break;
    }

    return MaterialApp(
      title: 'Quiz',
      debugShowCheckedModeBanner: false,
      theme: selectedTheme,
      themeMode: ThemeMode.light, // Selalu light mode, tema dikelola manual
      home: const SplashScreen(), // Menampilkan splash screen custom terlebih dahulu
    );
  }
}
