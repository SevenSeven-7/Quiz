import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/layanan/layanan_firebase.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';
import '../../inti/penyedia/penyedia_tema.dart';
import '../kuis/layar_kuis.dart';

class LevelSelectionScreen extends ConsumerWidget {
  final PartModel part;
  const LevelSelectionScreen({super.key, required this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final appTheme = ref.watch(temaProvider);
    final isComputer = appTheme == AppThemeMode.computer;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: isComputer ? AppColors.backgroundComputerGradient : AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar Custom
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 20, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isComputer ? AppColors.surfaceComputer : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(isComputer ? 4 : 12),
                          border: Border.all(color: isComputer ? AppColors.surfaceComputerBorder : Colors.white10),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: isComputer ? AppColors.textPrimaryComputer : Colors.white, size: 20),
                      ),
                    ),
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                        child: Text(
                          part.cleanTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isComputer ? AppColors.textPrimaryComputer : Colors.white,
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
                  future: FirebaseService().getLevels(part.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
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
                    final width = MediaQuery.of(context).size.width;
                    int crossAxisCount = 5;
                    if (width > 1200) {
                      crossAxisCount = 12;
                    } else if (width > 900) crossAxisCount = 10;
                    else if (width > 600) crossAxisCount = 8;

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: levels.length,
                        itemBuilder: (context, index) {
                          final levelData = levels[index];
                          final levelNumber = levelData.order;
                          final levelId = levelData.id;
                          final stars = progress.levelStars[levelId] ?? 0;

                          // Level 1 selalu terbuka, level selanjutnya
                          // terbuka jika level sebelumnya sudah mendapat bintang
                          bool isUnlocked;
                          if (index == 0) {
                            isUnlocked = true;
                          } else {
                            final prevLevelId = levels[index - 1].id;
                            final prevStars = progress.levelStars[prevLevelId] ?? 0;
                            isUnlocked = prevStars > 0;
                          }

                          return _buildLevelButton(
                            context, levelNumber, isUnlocked, stars, levelData, index, isComputer,
                          );
                        },
                      ),
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
    BuildContext context, int number, bool isUnlocked, int stars, LevelModel levelData, int index, bool isComputer,
  ) {
    final isComplete = stars == 3;
    Color? borderColor;
    Gradient? gradient;

    if (isComplete) {
      borderColor = isComputer ? AppColors.primaryComputerLight : AppColors.gold;
      gradient = isComputer ? AppColors.primaryComputerGradient : const LinearGradient(
        colors: [Color(0xFF92400E), Color(0xFF1A1A40)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (isUnlocked) {
      borderColor = (isComputer ? AppColors.primaryComputer : AppColors.primary).withOpacity(0.5);
    }

    return InkWell(
      onTap: isUnlocked && levelData.questions.isNotEmpty
          ? () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => QuizScreen(level: levelData)),
              )
          : null,
      borderRadius: BorderRadius.circular(isComputer ? 4 : 14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null
              ? (isUnlocked ? (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLight) : AppColors.surface.withOpacity(0.3))
              : null,
          borderRadius: BorderRadius.circular(isComputer ? 4 : 14),
          border: Border.all(
            color: borderColor ?? (isComputer ? AppColors.surfaceComputerBorder : Colors.white.withOpacity(0.05)),
            width: isComplete ? 1.5 : 1,
          ),
          boxShadow: isComputer ? AppColors.computerCardShadow : (isComplete
              ? [BoxShadow(color: AppColors.gold.withOpacity(0.2), blurRadius: 8)]
              : isUnlocked
                  ? [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 6)]
                  : null),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isUnlocked)
              const Icon(Icons.lock_rounded, size: 18, color: Colors.white24)
            else ...[
              Text(
                '$number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isComplete ? (isComputer ? AppColors.textPrimaryComputer : AppColors.gold) : (isComputer ? AppColors.textPrimaryComputer : Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Icon(
                    i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 9,
                    color: i < stars ? AppColors.gold : Colors.white12,
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 15).ms, duration: 250.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          delay: (index * 15).ms,
          duration: 250.ms,
          curve: Curves.easeOutBack,
        );
  }
}
