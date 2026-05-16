import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/firebase_service.dart';
import '../../models/models.dart';
import '../progress/progress_provider.dart';
import '../quiz/quiz_screen.dart';

class LevelSelectionScreen extends ConsumerWidget {
  final PartModel part;

  const LevelSelectionScreen({super.key, required this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(part.title),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<LevelModel>>(
        future: FirebaseService().getLevels(part.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final levels = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
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

                return _buildLevelButton(context, levelNumber, isUnlocked, stars, levelData);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLevelButton(BuildContext context, int number, bool isUnlocked, int stars, LevelModel levelData) {
    return InkWell(
      onTap: isUnlocked && levelData.questions.isNotEmpty
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuizScreen(level: levelData),
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.surface : AppColors.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: isUnlocked ? Border.all(color: AppColors.primary.withOpacity(0.5)) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isUnlocked)
              const Icon(Icons.lock, size: 20, color: Colors.grey)
            else ...[
              Text(
                '$number',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    Icons.star,
                    size: 10,
                    color: index < stars ? Colors.amber : Colors.grey.withOpacity(0.3),
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
