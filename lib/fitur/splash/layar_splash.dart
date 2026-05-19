import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import 'layar_buat_nama.dart';
import '../beranda/layar_utama.dart';

// Kelas SplashScreen mengatur kemunculan layar animasi pembuka dengan efek partikel neon.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _loadingController;

  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Kontroler partikel melayang
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Kontroler efek glow berpulsa pada logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Kontroler efek shimmer pada teks
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Kontroler loading dots
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    // Inisialisasi partikel secara acak
    _initParticles();

    // Navigasi setelah 2 detik
    _navigateToHome();
  }

  void _initParticles() {
    for (int i = 0; i < 40; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 3 + 1,
        speed: _random.nextDouble() * 0.3 + 0.1,
        opacity: _random.nextDouble() * 0.6 + 0.2,
        color: _random.nextBool() ? AppColors.primary : AppColors.accent,
      ));
    }
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      final prefs = await SharedPreferences.getInstance();
      final playerName = prefs.getString('player_name');

      if (playerName != null && playerName.trim().isNotEmpty) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => const MainNavigationScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => const LayarBuatNama(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = size.shortestSide * 0.32;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050510), Color(0xFF0A0820), Color(0xFF050510)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Layer partikel melayang
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ParticlePainter(_particles, _particleController.value),
                  size: size,
                );
              },
            ),

            // Lingkaran glow besar di belakang logo
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final glowRadius = 120 + _pulseController.value * 30;
                return Center(
                  child: Container(
                    width: glowRadius * 2,
                    height: glowRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.15 + _pulseController.value * 0.1),
                          AppColors.accent.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Konten utama (logo + teks + loading)
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo dengan efek glow berpulsa
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3 + _pulseController.value * 0.3),
                                blurRadius: 40 + _pulseController.value * 20,
                                spreadRadius: 5 + _pulseController.value * 5,
                              ),
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.2 + _pulseController.value * 0.2),
                                blurRadius: 60 + _pulseController.value * 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: child,
                        );
                      },
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1.0, 1.0),
                          duration: 900.ms,
                          curve: Curves.easeOutBack,
                        )
                        .fadeIn(duration: 700.ms),

                    const SizedBox(height: 48),

                    // Teks "Quiz" dengan efek shimmer
                    AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            final shimmerPos = _shimmerController.value;
                            return LinearGradient(
                              colors: const [
                                Color(0xFFA855F7),
                                Color(0xFFFFFFFF),
                                Color(0xFF06B6D4),
                                Color(0xFFA855F7),
                              ],
                              stops: [
                                (shimmerPos - 0.4).clamp(0.0, 1.0),
                                shimmerPos.clamp(0.0, 1.0),
                                (shimmerPos + 0.2).clamp(0.0, 1.0),
                                (shimmerPos + 0.6).clamp(0.0, 1.0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: child!,
                        );
                      },
                      child: Text(
                        'Quiz',
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 10,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: AppColors.primary.withOpacity(0.8),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 800.ms)
                        .slideY(begin: 0.3, end: 0, delay: 500.ms, duration: 800.ms, curve: Curves.easeOut),

                    const SizedBox(height: 12),

                    // Tagline
                    Text(
                      'Asah kecerdasanmu',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withOpacity(0.8),
                        letterSpacing: 2,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 900.ms, duration: 600.ms),

                    const SizedBox(height: 64),

                    // Loading dots animatif
                    AnimatedBuilder(
                      animation: _loadingController,
                      builder: (context, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            final delay = index / 3;
                            final animValue = (((_loadingController.value - delay) % 1.0 + 1.0) % 1.0);
                            final scale = animValue < 0.5
                                ? 1.0 + animValue * 0.8
                                : 1.4 - (animValue - 0.5) * 0.8;
                            final opacity = 0.3 + animValue * 0.7;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Transform.scale(
                                scale: scale.clamp(0.8, 1.5),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == 1
                                        ? AppColors.accent.withOpacity(opacity)
                                        : AppColors.primary.withOpacity(opacity),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (index == 1 ? AppColors.accent : AppColors.primary)
                                            .withOpacity(opacity * 0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ).animate().fadeIn(delay: 1200.ms, duration: 600.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model data partikel bintang melayang
class _Particle {
  double x, y, size, speed, opacity;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
  });
}

// CustomPainter untuk menggambar partikel melayang naik secara otomatis
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;

  _ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final yPos = (p.y - animationValue * p.speed) % 1.0;
      final paint = Paint()
        ..color = p.color.withOpacity(p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(
        Offset(p.x * size.width, yPos * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
