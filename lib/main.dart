import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inti/tema/tema_aplikasi.dart';
import 'fitur/splash/layar_splash.dart';
import 'inti/layanan/layanan_firebase.dart';
import 'firebase_options.dart';

// Fungsi utama (entry point) aplikasi kuis Flutter
void main() async {
  // Memastikan binding framework Flutter telah terinisialisasi sebelum proses sinkronisasi lainnya
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Menginisialisasi Firebase Firestore secara asinkron dengan konfigurasi platform
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Menjalankan seeder data kuis secara non-blocking di latar belakang
    FirebaseService().seedDataIfNeeded();
  } catch (e) {
    debugPrint('Firebase gagal diinisialisasi: $e');
  }
  
  runApp(
    // Membungkus seluruh aplikasi kuis dalam ProviderScope untuk memfungsikan Riverpod State Management
    const ProviderScope(
      child: QuizApp(),
    ),
  );
}

// Widget utama root yang menyusun kerangka dasar MaterialApp
class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz',
      debugShowCheckedModeBanner: false, // Menghilangkan banner mode debug di pojok kanan atas
      theme: AppTheme.darkTheme, // Menerapkan tema gelap aplikasi kuis
      home: const SplashScreen(), // Memulai dengan tampilan pembuka (splash screen)
    );
  }
}
