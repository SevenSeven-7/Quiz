import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/layanan/layanan_firebase.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';
import '../kuis/layar_kuis.dart';

// Kelas LevelSelectionScreen menyusun tampilan pilihan tingkat/level kuis untuk setiap bagian.
class LevelSelectionScreen extends ConsumerWidget {
  final PartModel part;

  const LevelSelectionScreen({super.key, required this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          part.cleanTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Memuat tingkat/level kuis berdasarkan ID bagian secara asinkron dari FirebaseService
      body: FutureBuilder<List<LevelModel>>(
        future: FirebaseService().getLevels(part.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final levels = snapshot.data!;

          final width = MediaQuery.of(context).size.width;
          int crossAxisCount = 5;
          if (width > 1200) {
            crossAxisCount = 12;
          } else if (width > 900) {
            crossAxisCount = 10;
          } else if (width > 600) {
            crossAxisCount = 8;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // Grid dinamis berdasarkan lebar layar peranti
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final levelData = levels[index];
                final levelNumber = levelData.order;
                final levelId = levelData.id;
                // Memeriksa apakah level terkunci atau terbuka dan bintang yang didapat
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

  // Widget pembangun tombol level kuis individual
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
              // Menampilkan ikon bintang yang telah berhasil diraih di level ini
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
