import 'dart:math' as math;
import 'package:quiz/inti/utils/audio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/layanan/layanan_api.dart';
import '../../inti/layanan/layanan_data.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';
import '../kuis/layar_kuis.dart';
import '../../inti/utils/ornament_helper.dart';

class LevelSelectionScreen extends ConsumerWidget {
  final PartModel part;
  final String? categoryName;
  final List<Color>? gradientColors;
  const LevelSelectionScreen({super.key, required this.part, this.categoryName, this.gradientColors});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final bgGradient = AppColors.backgroundGradient;
    final catName = categoryName ?? part.cleanTitle;
    final ornaments = OrnamentHelper.getOrnamentsForCategory(catName);
    final mainChar = OrnamentHelper.getMainCharacterForCategory(catName);

    final bgColors = gradientColors != null 
        ? [gradientColors![0].withValues(alpha: 0.15), gradientColors![1].withValues(alpha: 0.05)]
        : AppColors.backgroundGradient.colors;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar Custom
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 20, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () { AudioHelper.playClick(); Navigator.of(context).pop(); }, icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                        child: Text(
                          catName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              // Grid Level
              Expanded(
                child: FutureBuilder<List<LevelModel>>(
                  future: DataService().getLevels(part.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Memuat level...',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      );
                    }

                    final levels = snapshot.data!;
                    return Stack(
                      children: [
                        // Giant Watermark di tengah
                        Center(
                          child: Opacity(
                            opacity: 0.04,
                            child: Text(
                              mainChar,
                              style: const TextStyle(fontSize: 350),
                            ),
                          ),
                        ),

                        // Latar Belakang Ornamen Dinamis (Sesuai Jumlah Karakter & Beda Posisi Tiap Kategori)
                        ...(() {
                          final rand = math.Random();
                          // Pola sebaran posisi agar tidak menumpuk
                          final aligns = [
                            const Alignment(-0.8, -0.8), const Alignment(0.8, -0.7),
                            const Alignment(-0.7, -0.4), const Alignment(0.7, -0.2),
                            const Alignment(-0.8, 0.1),  const Alignment(0.8, 0.4),
                            const Alignment(-0.6, 0.7),  const Alignment(0.6, 0.8),
                            const Alignment(0.0, -0.9),  const Alignment(-0.3, 0.9),
                            const Alignment(0.4, -0.5),  const Alignment(-0.2, 0.5),
                          ];
                          aligns.shuffle(rand);

                          return List.generate(ornaments.length, (i) {
                            final align = aligns[i % aligns.length];
                            final size = 35.0 + rand.nextInt(20); // Ukuran acak 35-55
                            final duration = 3 + rand.nextInt(3); // Durasi 3-5 detik
                            final animType = rand.nextInt(3); // 0, 1, 2
                            
                            var anim = Text(ornaments[i], style: TextStyle(fontSize: size))
                                .animate(onPlay: (c) => c.repeat(reverse: true));
                            
                            if (animType == 0) {
                              anim = anim.slideX(duration: duration.seconds, curve: Curves.easeInOutSine, begin: -0.05, end: 0.05);
                            } else if (animType == 1) {
                              anim = anim.slideY(duration: duration.seconds, curve: Curves.easeInOutSine, begin: -0.05, end: 0.05);
                            } else {
                              anim = anim.scale(duration: duration.seconds, curve: Curves.easeInOut, begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1));
                            }

                            return Align(
                              alignment: align,
                              child: anim,
                            );
                          });
                        })(),

                        // Modern Grid View for 100 levels
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: 80, bottom: 80),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 24,
                              crossAxisSpacing: 24,
                              childAspectRatio: 0.85, // Memberi ruang untuk teks di bawah
                            ),
                            itemCount: levels.length,
                            itemBuilder: (context, index) {
                              final levelData = levels[index];
                              final levelNumber = levelData.order;
                              final levelId = levelData.id;
                              final stars = progress.levelStars[levelId] ?? 0;

                              // Level 1 selalu terbuka
                              bool isUnlocked;
                              if (index == 0) {
                                isUnlocked = true;
                              } else {
                                final prevLevelId = levels[index - 1].id;
                                final prevStars = progress.levelStars[prevLevelId] ?? 0;
                                isUnlocked = prevStars > 0;
                              }

                              return Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  _buildLevelButton(
                                    context, levelNumber, isUnlocked, stars, levelData, index,
                                  ),
                                  
                                  // Bayangan bintang jika terbuka (di atas bulatan)
                                  if (isUnlocked && stars > 0)
                                    Positioned(
                                      top: -10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: AppColors.cardShadow,
                                          border: Border.all(color: Colors.black12, width: 0.5),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(3, (i) {
                                            return Icon(
                                              i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                                              size: 12,
                                              color: i < stars ? AppColors.gold : Colors.black12,
                                            );
                                          }),
                                        ),
                                      ),
                                    ).animate().fadeIn(delay: (index * 20 + 200).ms).slideY(begin: 0.5, end: 0),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(
    BuildContext context, int number, bool isUnlocked, int stars, LevelModel levelData, int index,
  ) {
    final isComplete = stars == 3;
    Color? borderColor;
    Gradient? gradient;

    if (isComplete) {
      borderColor = AppColors.gold.withValues(alpha: 0.8);
      gradient = AppColors.goldGradient;
    } else if (isUnlocked) {
      borderColor = AppColors.primary.withValues(alpha: 0.4);
      gradient = AppColors.primaryGradient;
    } else {
      borderColor = Colors.black12;
    }

    return InkWell(
      onTap: isUnlocked
          ? () async {
              AudioHelper.playClick();
              final fetchedQuestions = await ApiService().getQuestionsForLevel(levelData.partId, levelData.order);
              
              if (fetchedQuestions.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal memuat soal.'), backgroundColor: Colors.red),
                  );
                }
                return;
              }

              final newLevel = LevelModel(
                id: levelData.id,
                order: levelData.order,
                partId: levelData.partId,
                questions: fetchedQuestions,
                stars: levelData.stars,
                isUnlocked: levelData.isUnlocked,
              );

              if (context.mounted) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => QuizScreen(
                      level: newLevel, 
                      categoryName: categoryName,
                      gradientColors: gradientColors,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                );
              }
            }
          : null,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity, // Ambil lebar grid sepenuhnya
            height: 65,
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null
                  ? (isUnlocked ? AppColors.surface : AppColors.surfaceLight.withValues(alpha: 0.5))
                  : null,
              borderRadius: BorderRadius.circular(20), // Bentuk melengkung bukan bulat penuh
              border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: isUnlocked ? 2 : 1,
              ),
              boxShadow: isComplete
                  ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4))]
                  : isUnlocked
                      ? [BoxShadow(color: gradientColors != null ? gradientColors![0].withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))]
                      : null,
            ),
            child: Center(
              child: isUnlocked
                  ? Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: gradient != null ? Colors.white : AppColors.textPrimary,
                      ),
                    )
                  : const Icon(Icons.lock_rounded, color: Colors.black26, size: 24),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isUnlocked ? AppColors.surface.withValues(alpha: 0.8) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Lvl $number',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? AppColors.textPrimary : Colors.black38,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().scale(delay: ((index % 10) * 30).ms, duration: 400.ms, curve: Curves.easeOutBack);
  }
}
