import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/penyedia/penyedia_tema.dart';
import '../beranda/layar_utama.dart';
import '../progres/penyedia_progres.dart';

class LayarBuatNama extends ConsumerStatefulWidget {
  const LayarBuatNama({super.key});

  @override
  ConsumerState<LayarBuatNama> createState() => _LayarBuatNamaState();
}

class _LayarBuatNamaState extends ConsumerState<LayarBuatNama> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AnimationController _particleController;
  final List<_MiniParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < 25; i++) {
      _particles.add(_MiniParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2.5 + 1,
        speed: _random.nextDouble() * 0.2 + 0.05,
        opacity: _random.nextDouble() * 0.4 + 0.1,
        color: _random.nextBool() ? AppColors.primary : AppColors.accent,
      ));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  Future<void> _savePlayerName() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final playerName = _nameController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_name', playerName);
    await ref.read(progressProvider.notifier).syncWithFirebase(playerName);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const MainNavigationScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final size = MediaQuery.of(context).size;
    final appTheme = ref.watch(temaProvider);
    final isDark = appTheme == AppThemeMode.dark;
    final isComputer = appTheme == AppThemeMode.computer;

    final bgGradient = isComputer ? AppColors.backgroundComputerGradient : (isDark ? const LinearGradient(
            colors: [Color(0xFF050510), Color(0xFF0A0820), Color(0xFF050510)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ) : AppColors.backgroundLightGradient);

    final surfaceColor = isDark ? AppColors.surfaceLight : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightModeSecond);
    final textColor = isDark ? Colors.white : (isComputer ? AppColors.textPrimaryComputer : AppColors.textPrimaryLight);
    final secondaryTextColor = isComputer ? AppColors.textSecondaryComputer : (isDark ? AppColors.textSecondary : AppColors.textSecondaryLight);
    final primaryGrad = isComputer ? AppColors.primaryComputerGradient : AppColors.primaryGradient;
    final buttonGrad = isComputer ? AppColors.primaryComputerGradient : AppColors.buttonGradient;
    final glow = isComputer ? AppColors.computerShadow : AppColors.primaryGlow;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: bgGradient),
        child: Stack(
          children: [
            // Partikel latar
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _MiniParticlePainter(_particles, _particleController.value),
                  size: size,
                );
              },
            ),

            // Lingkaran glow
            Positioned(
              top: -100,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Konten utama
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 40, 24, bottomPadding + 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // Logo dengan glow
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: primaryGrad,
                            boxShadow: glow,
                          ),
                          child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 52),
                        )
                            .animate()
                            .scale(duration: 700.ms, curve: Curves.easeOutBack)
                            .fadeIn(),
                      ),

                      const SizedBox(height: 24),

                      // Teks Quiz shimmer
                      Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => isComputer ? AppColors.primaryComputerGradient.createShader(bounds) : AppColors.primaryGradient.createShader(bounds),
                          child: Text(
                            'Quiz',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: isComputer ? AppColors.textPrimaryComputer : Colors.white,
                              letterSpacing: 6,
                            ),
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: Text(
                          'Asah kecerdasanmu ke level maksimal!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ).animate().fadeIn(delay: 350.ms),
                      ),

                      const SizedBox(height: 52),

                      // Kartu Input Glassmorphism
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: surfaceColor.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: isComputer ? AppColors.surfaceComputerBorder : AppColors.primary.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                          boxShadow: isComputer ? AppColors.computerCardShadow : [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              blurRadius: 24,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: primaryGrad,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Buat Nama Pemain',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Nama ini akan digunakan untuk melacak skor dan pencapaianmu.',
                              style: TextStyle(color: secondaryTextColor, fontSize: 12),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _nameController,
                              style: TextStyle(color: textColor, fontSize: 16),
                              maxLength: 15,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintText: 'Masukkan namamu...',
                                hintStyle: TextStyle(color: isComputer ? Colors.black38 : (isDark ? Colors.white30 : Colors.black38)),
                                counterStyle: TextStyle(color: secondaryTextColor),
                                prefixIcon: Icon(Icons.person_rounded, color: isComputer ? AppColors.primaryComputer : AppColors.primary),
                                filled: true,
                                fillColor: isComputer ? AppColors.surfaceComputerSecond : (isDark ? AppColors.background.withValues(alpha: 0.8) : AppColors.surfaceLightBlue),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: isComputer ? AppColors.primaryComputer : AppColors.primary, width: 1.5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: AppColors.failure, width: 1.5),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: AppColors.failure, width: 1.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Nama tidak boleh kosong!';
                                if (value.trim().length < 3) return 'Minimal 3 karakter!';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 28),

                      // Tombol Mulai dengan gradien
                      Container(
                        decoration: BoxDecoration(
                          gradient: buttonGrad,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: glow,
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _savePlayerName,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Mulai Petualangan',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                                  ],
                                ),
                        ),
                      ).animate().fadeIn(delay: 700.ms),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniParticle {
  double x, y, size, speed, opacity;
  Color color;
  _MiniParticle({required this.x, required this.y, required this.size, required this.speed, required this.opacity, required this.color});
}

class _MiniParticlePainter extends CustomPainter {
  final List<_MiniParticle> particles;
  final double animValue;
  _MiniParticlePainter(this.particles, this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final yPos = (p.y - animValue * p.speed) % 1.0;
      final paint = Paint()..color = p.color.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x * size.width, yPos * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniParticlePainter oldDelegate) => true;
}
