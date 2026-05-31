import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'inti/tema/tema_aplikasi.dart';
import 'inti/penyedia/penyedia_tema.dart';
import 'fitur/splash/layar_splash.dart';
import 'inti/layanan/layanan_notifikasi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Mengaktifkan mode layar penuh (Immersive Mode) agar navigasi HP disembunyikan
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Jalankan aplikasi secepat mungkin untuk menutup native splash screen
  runApp(
    const ProviderScope(
      child: QuizApp(),
    ),
  );
}

// Widget utama yang merespons perubahan tema secara real-time
class QuizApp extends ConsumerStatefulWidget {
  const QuizApp({super.key});

  @override
  ConsumerState<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends ConsumerState<QuizApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Inisialisasi notifikasi setelah animasi splash screen selesai (delay 3 detik)
    // Ini memastikan animasi loading tidak patah-patah!
    Future.delayed(const Duration(seconds: 3), () async {
      final notifService = NotificationService();
      await notifService.init();
      await notifService.requestPermissions();
      notifService.cancelAllNotifications();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Menjadwalkan pengingat saat aplikasi masuk background atau ditutup
      NotificationService().scheduleReminderNotification();
    } else if (state == AppLifecycleState.resumed) {
      // Membatalkan notifikasi saat aplikasi dibuka kembali
      NotificationService().cancelAllNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
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
