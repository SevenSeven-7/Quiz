import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/layanan/layanan_firebase.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';
import '../kuis/layar_kuis.dart';

class LevelSelectionScreen extends ConsumerWidget {
  final PartModel part;
  const LevelSelectionScreen({super.key, required this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
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
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                        child: Text(
                          part.cleanTitle,
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
                    if (width > 1200) crossAxisCount = 12;
                    else if (width > 900) crossAxisCount = 10;
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
                          final isUnlocked = progress.unlockedLevels[levelId] ?? false;
                          final stars = progress.levelStars[levelId] ?? 0;

                          return _buildLevelButton(
                            context, levelNumber, isUnlocked, stars, levelData, index,
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
    BuildContext context, int number, bool isUnlocked, int stars, LevelModel levelData, int index,
  ) {
    final isComplete = stars == 3;
    Color? borderColor;
    Gradient? gradient;

    if (isComplete) {
      borderColor = AppColors.gold;
      gradient = const LinearGradient(
        colors: [Color(0xFF92400E), Color(0xFF1A1A40)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (isUnlocked) {
      borderColor = AppColors.primary.withOpacity(0.5);
    }

    return InkWell(
      onTap: isUnlocked && levelData.questions.isNotEmpty
          ? () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => QuizScreen(level: levelData)),
              )
          : null,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null
              ? (isUnlocked ? AppColors.surfaceLight : AppColors.surface.withOpacity(0.3))
              : null,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor ?? Colors.white.withOpacity(0.05),
            width: isComplete ? 1.5 : 1,
          ),
          boxShadow: isComplete
              ? [BoxShadow(color: AppColors.gold.withOpacity(0.2), blurRadius: 8)]
              : isUnlocked
                  ? [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 6)]
                  : null,
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
                  color: isComplete ? AppColors.gold : Colors.white,
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
