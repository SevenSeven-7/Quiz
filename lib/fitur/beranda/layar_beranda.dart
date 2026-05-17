import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/layanan/layanan_firebase.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';
import 'layar_pilih_level.dart';

// Kelas HomeScreen menyusun tampilan utama Halaman Beranda Kuis.
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
              _buildHeader(context), // Menyusun salam pembuka
              const SizedBox(height: 32),
              _buildScoreCard(context, ref), // Kartu akumulasi bintang/skor
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
                child: _buildPartList(context, ref), // Daftar bagian kuis (Bahasa Indonesia, Matematika, dll.)
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan teks salam pembuka di bagian atas layar.
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

  // Widget kartu penunjuk total bintang yang telah berhasil dikumpulkan oleh pemain.
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

  // Widget daftar list bagian kuis yang dihubungkan ke FirebaseService.
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
            // Memeriksa status pembukaan bagian kuis
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
