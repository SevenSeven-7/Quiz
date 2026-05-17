import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../beranda/layar_beranda.dart';

// Kelas SplashScreen mengatur kemunculan layar animasi pembuka aplikasi kuis pertama kali.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome(); // Memulai proses hitung mundur navigasi
  }

  // Fungsi pengatur penundaan durasi splash screen 2 detik sebelum masuk ke Halaman Beranda utama
  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan logo kuis dengan animasi fade-in dan scaling
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.shortestSide * 0.4,
              height: MediaQuery.of(context).size.shortestSide * 0.4,
              fit: BoxFit.contain,
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(delay: 200.ms, duration: 600.ms),
            const SizedBox(height: 24),
            // Teks judul aplikasi dengan animasi geser dan pudar
            Text(
              'QUIZ',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    letterSpacing: 8,
                    fontSize: 42,
                  ),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 800.ms)
                .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}
