import '../../inti/utils/audio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/layanan/layanan_data.dart';
import '../../inti/penyedia/penyedia_tema.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';
import 'layar_pilih_level.dart';
import 'layar_utama.dart';
import '../../inti/widget/animasi_pendar.dart';
import 'widget_ikon_gelar.dart';

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
    final appTheme = ref.watch(temaProvider);
    final isDark = appTheme == AppThemeMode.dark;
    final isComputer = appTheme == AppThemeMode.computer;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header TETAP DI ATAS - tidak ikut scroll
            _buildHeader(context, playerName, progress, isDark, isComputer),
            // Score Card TETAP DI ATAS - tidak ikut scroll
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: _buildScoreCard(context, progress, isDark, isComputer),
            ),
            // Kategori label TETAP DI ATAS
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      gradient: isComputer ? AppColors.primaryComputerGradient : AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(isComputer ? 0 : 4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Kategori Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : (isComputer ? AppColors.textPrimaryComputer : AppColors.textPrimaryLight),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms),
            ),
            // Konten yang bisa di-scroll
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Daftar Kategori
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    sliver: _buildPartList(context, ref, progress, isDark, isComputer),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // --- MOD MENU SEMENTARA ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: isDark ? AppColors.surfaceLight : Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (context) => Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('MOD MENU (SEMENTARA)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 12)),
                      onPressed: () {
                        ref.read(progressProvider.notifier).addModStars(300);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.star, color: Colors.white),
                      label: const Text('Tambah 300 Bintang (+1 Gelar)', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      onPressed: () {
                        // Reset Bintang: kurangi semua mod_stars dan reset aslinya
                        ref.read(progressProvider.notifier).resetProgress();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Progres Kembali Awal'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.bug_report_rounded, color: Colors.white),
        label: const Text('MOD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String playerName, ProgressState progress, bool isDark, bool isComputer) {
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
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
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
                      color: Colors.white, // Putih karena kena ShaderMask
                    ),
                  ),
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              ],
            ),
          ),
          // Avatar mini
          AnimasiPendar(
            warna: progress.warnaGelar,
            isCircle: !isComputer,
            borderRadius: isComputer ? 8 : 0,
            borderWidth: 2.0,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: isComputer ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: isComputer ? BorderRadius.circular(8) : null,
                gradient: isComputer ? AppColors.primaryComputerGradient : AppColors.primaryGradient,
                boxShadow: isComputer ? AppColors.computerShadow : (isDark ? AppColors.primaryGlow : AppColors.lightShadow),
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
            ),
          ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, ProgressState progress, bool isDark, bool isComputer) {
    final totalStars = progress.totalStars;
    final gelar = progress.gelarKecerdasan;
    final warnaGelar = progress.warnaGelar;
    const maxStars = 2100;
    final progressValue = (totalStars / maxStars).clamp(0.0, 1.0);

    return AnimasiPendar(
      warna: warnaGelar,
      borderRadius: isComputer ? 4 : 24,
      borderWidth: 2.0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceLight.withValues(alpha: 0.7) : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightModeSecond.withValues(alpha: 0.8)),
          borderRadius: BorderRadius.circular(isComputer ? 4 : 24),
          boxShadow: isComputer ? AppColors.computerCardShadow : [
            BoxShadow(
              color: warnaGelar.withValues(alpha: 0.1),
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: warnaGelar.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: WidgetIkonGelar(gelar: gelar, warnaGelar: warnaGelar),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tingkat Kecerdasan',
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
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
                  Text(
                    'Bintang',
                    style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight, fontSize: 11),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.gold, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$totalStars',
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
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
                    style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight, fontSize: 11),
                  ),
                  Text(
                    '${(progressValue * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(isComputer ? 0 : 8),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: isDark ? Colors.white10 : Colors.black12,
                  valueColor: AlwaysStoppedAnimation<Color>(isComputer ? AppColors.accentComputer : warnaGelar),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildPartList(BuildContext context, WidgetRef ref, ProgressState progress, bool isDark, bool isComputer) {
    return FutureBuilder<List<PartModel>>(
      future: DataService().getParts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: _buildShimmerLoading(isDark),
          );
        }

        final parts = snapshot.data!;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final part = parts[index];
              // Semua kategori pelajaran selalu terbuka - bebas dipilih pemain
              const isUnlocked = true;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildPartCard(context, part, isUnlocked, index, isDark, isComputer),
              );
            },
            childCount: parts.length,
          ),
        );
      },
    );
  }

  Widget _buildPartCard(BuildContext context, PartModel part, bool isUnlocked, int index, bool isDark, bool isComputer) {
    // Urutan: Agama Islam, B.Indonesia, Matematika, IPA, IPS, PPKn, B.Inggris
    final icons = [
      Icons.mosque_rounded,        // Agama Islam
      Icons.language_rounded,      // Bahasa Indonesia
      Icons.calculate_rounded,     // Matematika
      Icons.science_rounded,       // IPA
      Icons.public_rounded,        // IPS
      Icons.balance_rounded,       // PPKn
      Icons.menu_book_rounded,     // Bahasa Inggris
    ];
    final gradients = [
      [const Color(0xFF16A34A), const Color(0xFF4ADE80)], // Agama Islam — Hijau
      [const Color(0xFF7C3AED), const Color(0xFF06B6D4)], // B.Indonesia — Violet-Cyan
      [const Color(0xFF059669), const Color(0xFF34D399)], // Matematika — Emerald
      [const Color(0xFFDC2626), const Color(0xFFF97316)], // IPA — Merah-Oranye
      [const Color(0xFFD97706), const Color(0xFFFBBF24)], // IPS — Amber-Gold
      [const Color(0xFFE11D48), const Color(0xFFF43F5E)], // PPKn — Rose
      [const Color(0xFF0284C7), const Color(0xFF38BDF8)], // B.Inggris — Biru
    ];
    final grad = gradients[index % gradients.length];
    final icon = icons[index % icons.length];

    return InkWell(
      onTap: isUnlocked
          ? () {
              AudioHelper.playClick();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LevelSelectionScreen(part: part)),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(isComputer ? 4 : 20),
      child: AnimasiPendar(
        warna: isUnlocked ? grad[0] : (isDark ? Colors.white24 : Colors.black26),
        borderRadius: isComputer ? 4 : 20,
        borderWidth: 2.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceLight.withValues(alpha: 0.6) : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightModeSecond.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(isComputer ? 4 : 20),
            boxShadow: isComputer ? AppColors.computerCardShadow : null,
          ),
          child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: isUnlocked
                    ? (isComputer ? AppColors.primaryComputerGradient : LinearGradient(colors: grad, begin: Alignment.topLeft, end: Alignment.bottomRight))
                    : null,
                color: isUnlocked ? null : (isDark ? Colors.white10 : Colors.black12),
                borderRadius: BorderRadius.circular(isComputer ? 4 : 16),
                boxShadow: isUnlocked
                    ? [BoxShadow(color: isComputer ? Colors.black12 : grad[0].withValues(alpha: 0.3), blurRadius: 12)]
                    : null,
              ),
              child: Icon(
                isUnlocked ? icon : Icons.lock_rounded,
                color: isUnlocked ? Colors.white : (isDark ? Colors.white30 : Colors.black26),
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
                      color: isUnlocked 
                          ? (isDark ? Colors.white : AppColors.textPrimaryLight) 
                          : (isDark ? Colors.white38 : Colors.black38),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 18,
                    child: MarqueeText(
                      text: isUnlocked ? part.description : 'Selesaikan bagian sebelumnya',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark 
                            ? AppColors.textSecondary.withValues(alpha: isUnlocked ? 1.0 : 0.5)
                            : AppColors.textSecondaryLight.withValues(alpha: isUnlocked ? 1.0 : 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isUnlocked)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: isComputer ? AppColors.primaryComputerGradient : LinearGradient(colors: grad, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(isComputer ? 4 : 12),
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
              )
            else
              Icon(Icons.lock_outline_rounded, color: isDark ? Colors.white24 : Colors.black12, size: 20),
          ],
        ),
      ),
      ),
    ).animate().fadeIn(delay: (300 + index * 100).ms, duration: 400.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildShimmerLoading(bool isDark) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            height: 92,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceLight.withValues(alpha: 0.3) : AppColors.surfaceLightModeSecond.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(
                duration: 1200.ms,
                color: isDark ? Colors.white10 : Colors.black12,
              ),
        ),
      ),
    );
  }
}
