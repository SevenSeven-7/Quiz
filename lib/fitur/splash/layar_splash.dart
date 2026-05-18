import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import 'layar_buat_nama.dart';
import '../beranda/layar_utama.dart';

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

  // Fungsi pengatur penundaan durasi splash screen 2 detik sebelum masuk ke Halaman Beranda utama agar logo neon tampil indah
  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      final prefs = await SharedPreferences.getInstance();
      final playerName = prefs.getString('player_name');

      if (playerName != null && playerName.trim().isNotEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LayarBuatNama()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth > 600;
    final logoSize = MediaQuery.of(context).size.shortestSide * (isTabletOrDesktop ? 0.25 : 0.35);
    final fontSize = isTabletOrDesktop ? 56.0 : 42.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menampilkan logo kuis dengan animasi fade-in dan scaling
              Image.asset(
                'assets/images/logo.png',
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(delay: 200.ms, duration: 600.ms),
              const SizedBox(height: 80), // Memperlebar jarak dengan sangat aman agar logo dan teks tidak bertindih
              // Teks judul aplikasi dengan nama Quiz menggunakan Q kapital
              Padding(
                padding: const EdgeInsets.only(left: 8.0), // Menyimbangkan letterSpacing agar posisi teks simetris di tengah
                child: Text(
                  'Quiz',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        letterSpacing: 8,
                        fontSize: fontSize,
                      ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 800.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
