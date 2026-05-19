import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/layanan/layanan_firebase.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';
import 'layar_pilih_level.dart';
import 'layar_utama.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 11) return Icons.wb_sunny_rounded;
    if (hour < 15) return Icons.light_mode_rounded;
    if (hour < 18) return Icons.wb_twilight_rounded;
    return Icons.nights_stay_rounded;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerName = ref.watch(playerNameProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(context, playerName, progress),
            ),
            // Score Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: _buildScoreCard(context, progress),
              ),
            ),
            // Kategori label
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Kategori Quiz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms),
              ),
            ),
            // Daftar Kategori
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: _buildPartList(context, ref, progress),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String playerName, ProgressState progress) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_getGreetingIcon(), color: AppColors.gold, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _getGreeting(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 4),
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    playerName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              ],
            ),
          ),
          // Avatar mini
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: AppColors.primaryGlow,
            ),
            child: Center(
              child: Text(
                playerName.isNotEmpty ? playerName[0].toUpperCase() : 'P',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, ProgressState progress) {
    final totalStars = progress.totalStars;
    final gelar = progress.gelarKecerdasan;
    final warnaGelar = progress.warnaGelar;
    final maxStars = 600;
    final progressValue = (totalStars / maxStars).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: warnaGelar.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: warnaGelar.withOpacity(0.1),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: warnaGelar.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.psychology_rounded, color: warnaGelar, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tingkat Kecerdasan',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      gelar,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: warnaGelar,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Bintang',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.gold, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$totalStars',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menuju level berikutnya',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                  Text(
                    '${(progressValue * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(warnaGelar),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildPartList(BuildContext context, WidgetRef ref, ProgressState progress) {
    return FutureBuilder<List<PartModel>>(
      future: FirebaseService().getParts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: _buildShimmerLoading(),
          );
        }

        final parts = snapshot.data!;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final part = parts[index];
              final isUnlocked = progress.unlockedParts.contains(part.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildPartCard(context, part, isUnlocked, index),
              );
            },
            childCount: parts.length,
          ),
        );
      },
    );
  }

  Widget _buildPartCard(BuildContext context, PartModel part, bool isUnlocked, int index) {
    final icons = [Icons.language_rounded, Icons.calculate_rounded, Icons.science_rounded, Icons.history_edu_rounded];
    final gradients = [
      [const Color(0xFF7C3AED), const Color(0xFF06B6D4)],
      [const Color(0xFF059669), const Color(0xFF34D399)],
      [const Color(0xFFDC2626), const Color(0xFFF97316)],
      [const Color(0xFFD97706), const Color(0xFFFBBF24)],
    ];
    final grad = gradients[index % gradients.length];
    final icon = icons[index % icons.length];

    return InkWell(
      onTap: isUnlocked
          ? () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LevelSelectionScreen(part: part)),
              )
          : null,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? Color(grad[0].value).withOpacity(0.3)
                : Colors.white.withOpacity(0.05),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: isUnlocked
                    ? LinearGradient(colors: grad, begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : null,
                color: isUnlocked ? null : Colors.white10,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isUnlocked
                    ? [BoxShadow(color: grad[0].withOpacity(0.3), blurRadius: 12)]
                    : null,
              ),
              child: Icon(
                isUnlocked ? icon : Icons.lock_rounded,
                color: isUnlocked ? Colors.white : Colors.white30,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    part.cleanTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Colors.white : Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUnlocked ? part.description : 'Selesaikan bagian sebelumnya',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(isUnlocked ? 1.0 : 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isUnlocked)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: grad, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
              )
            else
              const Icon(Icons.lock_outline_rounded, color: Colors.white24, size: 20),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (300 + index * 100).ms, duration: 400.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            height: 92,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(
                duration: 1200.ms,
                color: Colors.white10,
              ),
        ),
      ),
    );
  }
}
