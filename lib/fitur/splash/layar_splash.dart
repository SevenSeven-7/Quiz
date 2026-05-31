import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../inti/utils/transisi_halaman.dart';
import 'layar_buat_nama.dart';
import '../beranda/layar_utama.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/penyedia/penyedia_tema.dart';

// SplashScreen dengan animasi memukau dan logo Quiz
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
    
    // Pastikan frame pertama sudah digambar di layar sebelum memulai hitung mundur 1.05s
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _routing();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _routing() async {
    // Mulai hitung mundur 2.5 detik agar animasinya terasa pas dan tidak buru-buru
    await Future.delayed(const Duration(milliseconds: 2500));
    
    final prefs = await SharedPreferences.getInstance();
    final playerName = prefs.getString('player_name');
    if (!mounted) return;
    if (playerName != null && playerName.trim().isNotEmpty) {
      Navigator.of(context).pushReplacement(TransisiPremium(child: const MainNavigationScreen()));
    } else {
      Navigator.of(context).pushReplacement(TransisiPremium(child: const LayarBuatNama()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(temaProvider);
    final isDark = appTheme == AppThemeMode.dark;
    final isComputer = appTheme == AppThemeMode.computer;

    // Pilih warna dan gradien berdasarkan tema
    final bgColor = isDark
        ? AppColors.background
        : isComputer
            ? AppColors.backgroundComputer
            : AppColors.backgroundLightBlue;
    final gradient = isDark
        ? AppColors.backgroundGradient
        : isComputer
            ? AppColors.backgroundComputerGradient
            : AppColors.backgroundLightGradient;
    final textGradient = isComputer
        ? AppColors.primaryComputerGradient
        : AppColors.primaryGradient;
    final loadingColor = isComputer ? AppColors.accentComputer : AppColors.accent;

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo dengan animasi breathing ──────────────────────
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    final scale = 0.95 + (_pulseAnimation.value * 0.1);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        // Outer glow container — KOTAK TEGAS (Sesuai Logo)
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isComputer
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryComputer.withValues(alpha: 0.25),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.25),
                                    blurRadius: 25,
                                    spreadRadius: 4,
                                  ),
                                  BoxShadow(
                                    color: AppColors.accent.withValues(alpha: 0.15),
                                    blurRadius: 35,
                                    spreadRadius: 6,
                                  ),
                                ],
                        ),
                        // Ring border gradien (untuk tema komputer: abu, untuk neon: biru)
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16),
                            gradient: isComputer
                                ? AppColors.primaryComputerGradient
                                : AppColors.primaryGradient,
                          ),
                          child: Container(
                            // Background dalam kotak
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(14),
                              color: bgColor,
                            ),
                            // ClipRRect memastikan gambar logo ter-clip kotak tegas
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.0, 0.0), end: const Offset(1.0, 1.0), duration: 1200.ms, curve: Curves.elasticOut)
                .shimmer(duration: 1500.ms, delay: 800.ms, color: Colors.white, blendMode: BlendMode.overlay),

                const SizedBox(height: 30),

                // ── Teks "Quiz" ────────────────────────────────────────
                ShaderMask(
                  shaderCallback: (bounds) => textGradient.createShader(bounds),
                  child: Text(
                    'Quiz',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: isComputer ? 4 : 8,
                      fontFamily: isComputer ? 'Inter' : null,
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 700.ms, delay: 400.ms)
                .slideY(begin: 0.4, end: 0, duration: 700.ms, delay: 400.ms, curve: Curves.easeOutCubic),

                const SizedBox(height: 8),

                // ── Tagline ─────────────────────────────────────────────
                Text(
                  isComputer ? 'Platform Quiz Pendidikan Indonesia' : 'Belajar Lebih Seru!',
                  style: TextStyle(
                    fontSize: 14,
                    color: isComputer
                        ? AppColors.textSecondaryComputer
                        : (isDark ? AppColors.textSecondary : AppColors.textSecondaryLightBlue),
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms, delay: 700.ms),

                const SizedBox(height: 48),

                // ── Loading indicator ───────────────────────────────────
                if (isComputer) ...[
                  // Komputer: progress bar ramping bukan bulat
                  SizedBox(
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        backgroundColor: AppColors.surfaceComputerBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryComputer),
                        minHeight: 3,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 1000.ms),
                ] else ...[
                  // Neon: lingkaran glowing
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
                      strokeWidth: 2.5,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 1000.ms),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
