import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/firebase_service.dart';
import '../../models/models.dart';
import '../progress/progress_provider.dart';
import 'level_selection_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildScoreCard(context, ref),
              const SizedBox(height: 40),
              Text(
                'Pilih Bagian',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildPartList(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, Pemain',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Siap tantangan hari ini?',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    );
  }

  Widget _buildScoreCard(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    int totalStars = 0;
    progress.levelStars.forEach((key, value) => totalStars += value);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.stars,
            color: Colors.amber,
            size: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bintang Terkumpul',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '$totalStars',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartList(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return FutureBuilder<List<PartModel>>(
      future: FirebaseService().getParts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final parts = snapshot.data!;

        return ListView.separated(
          itemCount: parts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final part = parts[index];
            final isUnlocked = progress.unlockedParts.contains(part.id);

            return InkWell(
              onTap: isUnlocked
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LevelSelectionScreen(part: part),
                        ),
                      );
                    }
                  : null,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isUnlocked ? AppColors.surface : AppColors.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: isUnlocked ? Border.all(color: AppColors.primary.withOpacity(0.2)) : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        index == 0 ? Icons.language : Icons.calculate,
                        color: isUnlocked ? AppColors.primary : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            part.title,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked ? Colors.white : Colors.grey,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isUnlocked ? part.description : 'Tuntaskan Bagian 1 minimal 90% skor untuk membuka',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (!isUnlocked)
                      const Icon(Icons.lock, color: Colors.grey)
                    else
                      const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
