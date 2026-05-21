import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int stars;
  final String partId;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.stars,
    required this.partId,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late AnimationController _particleController;
  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    if (widget.stars == 3) {
      _initConfetti();
      _particleController.repeat();
    }
  }

  void _initConfetti() {
    final colors = [AppColors.gold, AppColors.primary, AppColors.accent, AppColors.success, Colors.pink];
    for (int i = 0; i < 60; i++) {
      _particles.add(_ConfettiParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 8 + 4,
        speed: _random.nextDouble() * 0.15 + 0.05,
        color: colors[_random.nextInt(colors.length)],
        rotation: _random.nextDouble() * pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.1,
        isCircle: _random.nextBool(),
      ));
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  String get _message {
    if (widget.score < (widget.totalQuestions * 0.5)) return 'Terus Berlatih! 💪';
    if (widget.score < widget.totalQuestions) return 'Bagus Sekali! 🎉';
    return 'Sempurna! 🔥';
  }

  Color get _messageColor {
    if (widget.score < (widget.totalQuestions * 0.5)) return AppColors.failure;
    if (widget.score < widget.totalQuestions) return AppColors.accent;
    return AppColors.gold;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.score / widget.totalQuestions * 100).round();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            // Partikel confetti (hanya saat 3 bintang)
            if (widget.stars == 3)
              AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ConfettiPainter(_particles, _particleController.value),
                    size: MediaQuery.of(context).size,
                  );
                },
              ),

            // Konten utama
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // Bintang rating dramatis
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final isEarned = index < widget.stars;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              isEarned ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: index == 1 ? 72 : 56,
                              color: isEarned ? AppColors.gold : Colors.white12,
                            )
                                .animate(delay: (600 + index * 250).ms)
                                .scale(
                                  begin: const Offset(0.0, 0.0),
                                  end: const Offset(1.0, 1.0),
                                  curve: Curves.easeOutBack,
                                  duration: 500.ms,
                                )
                                .then()
                                .custom(
                                  duration: 300.ms,
                                  builder: (context, value, child) => Container(
                                    decoration: isEarned
                                        ? BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.gold.withOpacity(value * 0.6),
                                                blurRadius: 20 * value,
                                                spreadRadius: 2 * value,
                                              ),
                                            ],
                                          )
                                        : null,
                                    child: child,
                                  ),
                                ),
                          );
                        }),
                      ),

                      const SizedBox(height: 32),

                      // Pesan motivasi
                      Text(
                        _message,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: _messageColor,
                        ),
                      ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 8),

                      const Text(
                        'Level telah selesai',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ).animate().fadeIn(delay: 1600.ms),

                      const SizedBox(height: 32),

                      // Kartu Skor
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: _messageColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _messageColor.withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [_messageColor, AppColors.primary],
                              ).createShader(bounds),
                              child: Text(
                                '${widget.score}/${widget.totalQuestions}',
                                style: const TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Text(
                              'Jawaban Benar',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                            const SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: widget.score / widget.totalQuestions,
                                backgroundColor: Colors.white10,
                                valueColor: AlwaysStoppedAnimation<Color>(_messageColor),
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$percentage% Akurasi',
                              style: TextStyle(
                                color: _messageColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 1800.ms).scale(
                            begin: const Offset(0.9, 0.9),
                            end: const Offset(1.0, 1.0),
                            delay: 1800.ms,
                          ),

                      const SizedBox(height: 32),

                      // Tombol aksi
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppColors.primaryGlow,
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text(
                            'Ke Daftar Level',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ).animate().fadeIn(delay: 2200.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text(
                            'Kembali ke Beranda',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ).animate().fadeIn(delay: 2400.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 20),
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

class _ConfettiParticle {
  double x, y, size, speed, rotation, rotationSpeed;
  Color color;
  bool isCircle;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double animValue;

  _ConfettiPainter(this.particles, this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final yPos = (p.y + animValue * p.speed) % 1.0;
      final xWave = p.x + sin(animValue * pi * 4 + p.y * 10) * 0.02;
      final paint = Paint()..color = p.color.withOpacity(0.85);

      canvas.save();
      canvas.translate(xWave * size.width, yPos * size.height);
      canvas.rotate(p.rotation + animValue * p.rotationSpeed * pi * 2);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size / 2),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
