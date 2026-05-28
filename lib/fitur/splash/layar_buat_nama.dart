import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/penyedia/penyedia_tema.dart';
import '../../inti/utils/audio_helper.dart';
import '../../inti/utils/audio_helper.dart';
import '../../inti/utils/transisi_halaman.dart';
import '../beranda/layar_utama.dart';
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
  List<_MiniParticle> _particles = [];
  final Random _random = Random();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_particles.isEmpty) {
      _rebuildParticles();
    }
  }

  /// Membangun ulang partikel dengan warna yang sesuai tema saat ini
  void _rebuildParticles() {
    final appTheme = ref.read(temaProvider);
    final isDark = appTheme == AppThemeMode.dark;
    final isComputer = appTheme == AppThemeMode.computer;

    // Pilih warna partikel berdasarkan tema agar selalu terlihat
    final Color particleColorA;
    final Color particleColorB;

    if (isComputer) {
      // Mode Komputer: partikel abu-abu gelap agar terlihat di background putih
      particleColorA = AppColors.primaryComputer.withValues(alpha: 0.35);
      particleColorB = AppColors.accentComputer.withValues(alpha: 0.25);
    } else if (isDark) {
      // Mode Gelap: partikel biru neon terang
      particleColorA = AppColors.primary.withValues(alpha: 0.5);
      particleColorB = AppColors.accent.withValues(alpha: 0.4);
    } else {
      // Mode Terang: partikel biru sedang agar terlihat di background biru muda
      particleColorA = AppColors.primary.withValues(alpha: 0.4);
      particleColorB = const Color(0xFF0066CC).withValues(alpha: 0.3);
    }

    _particles = List.generate(25, (i) => _MiniParticle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 2.5 + 1,
      speed: _random.nextDouble() * 0.2 + 0.05,
      opacity: _random.nextDouble() * 0.6 + 0.2,
      color: _random.nextBool() ? particleColorA : particleColorB,
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _particleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _savePlayerName() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final playerName = _nameController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_name', playerName);
    // Progress sudah otomatis tersimpan lokal
    if (mounted) {
      Navigator.of(context).pushReplacement(TransisiPremium(child: const MainNavigationScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final size = MediaQuery.of(context).size;
    final appTheme = ref.watch(temaProvider);
    final isDark = appTheme == AppThemeMode.dark;
    final isComputer = appTheme == AppThemeMode.computer;

    // Rebuild partikel setiap kali tema berubah
    _rebuildParticles();

    final bgGradient = isComputer
        ? AppColors.backgroundComputerGradient
        : (isDark
            ? const LinearGradient(
                colors: [Color(0xFF050510), Color(0xFF0A0820), Color(0xFF050510)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : AppColors.backgroundLightGradient);

    final surfaceColor = isDark
        ? AppColors.surfaceLight
        : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightModeSecond);
    final textColor = isDark
        ? Colors.white
        : (isComputer ? AppColors.textPrimaryComputer : AppColors.textPrimaryLight);
    final secondaryTextColor = isComputer
        ? AppColors.textSecondaryComputer
        : (isDark ? AppColors.textSecondary : AppColors.textSecondaryLight);
    final primaryGrad = isComputer ? AppColors.primaryComputerGradient : AppColors.primaryGradient;
    final buttonGrad = isComputer ? AppColors.primaryComputerGradient : AppColors.buttonGradient;

    // Warna glow lingkaran latar adaptif tema
    final glowCircleColor = isComputer
        ? AppColors.primaryComputer.withValues(alpha: 0.06)
        : (isDark
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.primary.withValues(alpha: 0.08));

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: bgGradient),
        child: Stack(
          children: [
            // ── Partikel latar (warna adaptif tema) ──────────────────
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _MiniParticlePainter(_particles, _particleController.value),
                  size: size,
                );
              },
            ),

            // ── Lingkaran glow dekoratif (kiri atas) ─────────────────
            Positioned(
              top: -100,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [glowCircleColor, Colors.transparent],
                  ),
                ),
              ),
            ),

            // ── Lingkaran glow dekoratif (kanan bawah) ───────────────
            Positioned(
              bottom: -80,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [glowCircleColor, Colors.transparent],
                  ),
                ),
              ),
            ),

            // ── Konten utama ──────────────────────────────────────────
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24, 40, 24, bottomPadding + 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),

                          // ── Logo kotak tegas dengan glow ────────────────
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16),
                                gradient: primaryGrad,
                                boxShadow: [
                                  BoxShadow(
                                    color: isComputer ? AppColors.primaryComputer.withValues(alpha: 0.3) : AppColors.primary.withValues(alpha: 0.4),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                            .animate()
                            .scale(begin: const Offset(0.0, 0.0), end: const Offset(1.0, 1.0), duration: 800.ms, curve: Curves.elasticOut)
                            .fadeIn(duration: 600.ms),
                          ),

                          const SizedBox(height: 24),

                          // ── Teks Quiz shimmer ─────────────────────────
                          Center(
                            child: ShaderMask(
                              shaderCallback: (bounds) => isComputer
                                  ? AppColors.primaryComputerGradient.createShader(bounds)
                                  : AppColors.primaryGradient.createShader(bounds),
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

                          // ── Kartu Input Glassmorphism ──────────────────
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: surfaceColor.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: _focusNode.hasFocus 
                                    ? (isComputer ? AppColors.primaryComputer : AppColors.primary)
                                    : (isComputer ? AppColors.surfaceComputerBorder : AppColors.primary.withValues(alpha: 0.25)),
                                width: _focusNode.hasFocus ? 2.5 : 1.5,
                              ),
                              boxShadow: isComputer
                                  ? AppColors.computerCardShadow
                                  : [
                                      BoxShadow(
                                        color: _focusNode.hasFocus ? AppColors.primary.withValues(alpha: 0.3) : AppColors.primary.withValues(alpha: 0.08),
                                        blurRadius: _focusNode.hasFocus ? 35 : 24,
                                        spreadRadius: _focusNode.hasFocus ? 4 : 1,
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
                                  focusNode: _focusNode,
                                  controller: _nameController,
                                  style: TextStyle(color: textColor, fontSize: 16),
                                  maxLength: 15,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan namamu...',
                                    hintStyle: TextStyle(
                                      color: isComputer
                                          ? Colors.black38
                                          : (isDark ? Colors.white30 : Colors.black38),
                                    ),
                                    counterStyle: TextStyle(color: secondaryTextColor),
                                    prefixIcon: Icon(
                                      Icons.person_rounded,
                                      color: isComputer ? AppColors.primaryComputer : AppColors.primary,
                                    ),
                                    filled: true,
                                    fillColor: isComputer
                                        ? AppColors.surfaceComputerSecond
                                        : (isDark
                                            ? AppColors.background.withValues(alpha: 0.8)
                                            : AppColors.surfaceLightBlue),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: isComputer ? AppColors.primaryComputer : AppColors.primary,
                                        width: 1.5,
                                      ),
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
                          ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),

                          const SizedBox(height: 28),

                          // ── Tombol Mulai dengan gradien ────────────────
                          Container(
                            decoration: BoxDecoration(
                              gradient: buttonGrad,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: isComputer ? AppColors.primaryComputer.withValues(alpha: 0.3) : AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : () {
                                AudioHelper.playClick();
                                _savePlayerName();
                              },
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
                          ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
                        ],
                      ),
                    ),
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
  _MiniParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
  });
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
