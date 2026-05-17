import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/layanan/layanan_firebase.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';
import 'layar_pilih_level.dart';
import 'layar_utama.dart'; // Mengimpor playerNameProvider

// Kelas HomeScreen menyusun tampilan utama Halaman Beranda Kuis.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerName = ref.watch(playerNameProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, playerName), // Menyusun salam pembuka dinamis
              const SizedBox(height: 24),
              _buildScoreCard(context, ref), // Kartu akumulasi bintang & tingkat kecerdasan dinamis
              const SizedBox(height: 32),
              Text(
                'Pilih Kategori Kuis',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 16),
              _buildPartList(context, ref), // Daftar bagian kuis
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan teks salam pembuka di bagian atas layar secara personal.
  Widget _buildHeader(BuildContext context, String playerName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, $playerName',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Siap asah otakmu hari ini?',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 24,
              ),
        ),
      ],
    );
  }

  // Widget kartu penunjuk total bintang yang telah berhasil dikumpulkan oleh pemain.
  Widget _buildScoreCard(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final totalStars = progress.totalStars;
    final gelar = progress.gelarKecerdasan;
    final warnaGelar = progress.warnaGelar;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: warnaGelar.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: warnaGelar.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: warnaGelar.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology,
                  color: warnaGelar,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tingkat Kecerdasan',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.8,
                          fontSize: 11,
                        ),
                  ),
                  Text(
                    gelar,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 20,
                          color: warnaGelar,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.stars,
                    color: Colors.amber,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bintang Terkumpul',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
              Text(
                '$totalStars ⭐',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      fontSize: 16,
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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                padding: const EdgeInsets.all(20),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            part.cleanTitle,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked ? Colors.white : Colors.grey,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isUnlocked ? part.description : 'Tuntaskan Bagian 1 untuk membuka',
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
                      const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
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
