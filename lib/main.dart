import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'inti/tema/tema_aplikasi.dart';
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
    
    // KUNCI KESTABILAN: Tunda inisialisasi berat selama 3 detik.
    // Ini memastikan seluruh resource HP fokus pada kelancaran animasi Splash Screen.
    // Jika user menutup aplikasi sebelum 3 detik, fungsi scheduleReminderNotification() 
    // di layanan_notifikasi.dart sudah memiliki 'await init()' cadangan sehingga tidak akan gagal.
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
    return MaterialApp(
      title: 'Quiz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, // Selalu light mode, tema dikelola manual
      home: const SplashScreen(), // Menampilkan splash screen custom terlebih dahulu
    );
  }
}
