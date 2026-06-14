import 'package:quiz/inti/utils/audio_helper.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../progres/penyedia_progres.dart';
import '../pengaturan/layar_pengaturan.dart';
import 'layar_beranda.dart';
import '../../inti/widget/animasi_pendar.dart';

// Provider reaktif untuk menyimpan dan memperbarui nama pemain secara waktu-nyata
final playerNameProvider = StateProvider<String>((ref) => 'Pemain');

// Layar utama yang menyediakan navigasi tab antara Beranda, Profil, dan Pengaturan.
class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _navAnimController;
  late ConfettiController _confettiController;

  final List<Widget> _pages = const [
    HomeScreen(),
    ProfileScreen(),
    LayarPengaturan(),
  ];

  @override
  void initState() {
    super.initState();
    _navAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _loadPlayerName();
  }

  @override
  void dispose() {
    _navAnimController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('player_name') ?? 'Pemain';
    ref.read(playerNameProvider.notifier).state = name;
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);

    // Pilih warna latar
    final bgColor = AppColors.background;
    final bgGradient = AppColors.backgroundGradient;

    ref.listen<ProgressState>(progressProvider, (previous, next) {
      if (next.newlyAchievedGelar != null) {
        _confettiController.play();
        AudioHelper.playClick();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'SELAMAT! Anda Naik Pangkat ke ${next.newlyAchievedGelar}!',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: next.warnaGelar,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          )
        );

        Future.microtask(() {
          ref.read(progressProvider.notifier).clearNewlyAchievedGelar();
        });
      }
    });

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background Gradient (Dynamic)
          Container(
            decoration: BoxDecoration(gradient: bgGradient),
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
          
          // Floating Bottom Navigation
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildFloatingBottomNav(progress.warnaGelar),
          ),
          
          // Confetti Overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: math.pi / 2, // Jatuh ke bawah
              maxBlastForce: 20,
              minBlastForce: 5,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.2,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNav(Color warnaGelar) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Beranda', warnaGelar),
                _buildNavItem(1, Icons.person_rounded, Icons.person_outline_rounded, 'Profil', warnaGelar),
                _buildNavItem(2, Icons.settings_rounded, Icons.settings_outlined, 'Pengaturan', warnaGelar),
              ],
            ),
          ).animate().slideY(begin: 1, end: 0, duration: 600.ms, curve: Curves.easeOutBack),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, Color warnaGelar) {
    final isActive = _currentIndex == index;
    const inactiveColor = AppColors.textSecondary;

    return GestureDetector(
      onTap: () {
        AudioHelper.playClick();
        if (_currentIndex != index) {
          setState(() => _currentIndex = index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Teks Label
            Positioned(
              bottom: 12,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isActive ? 1.0 : 0.7,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? AppColors.primary : inactiveColor,
                  ),
                ),
              ),
            ),
            
            // Ikon Pop-up
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              top: isActive ? -18 : 8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(isActive ? 12 : 0),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: isActive ? AppColors.primaryGlow : null,
                ),
                child: Icon(
                  isActive ? activeIcon : inactiveIcon,
                  color: isActive ? Colors.white : inactiveColor,
                  size: isActive ? 24 : 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Layar Profil Pemain
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerName = ref.watch(playerNameProvider);
    final progress = ref.watch(progressProvider);
    final totalStars = progress.totalStars;
    final gelar = progress.gelarKecerdasan;
    final warnaGelar = progress.warnaGelar;
    final bindoSolved = progress.indonesianSolved;
    final mathSolved = progress.mathSolved;

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by Stack in MainNavigationScreen
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header TETAP DI ATAS - tidak ikut scroll
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                    child: const Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                ],
              ),
            ),
            // Konten yang bisa di-scroll
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                  // Avatar Card
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: warnaGelar.withValues(alpha: 0.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: warnaGelar.withValues(alpha: 0.1),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        AnimasiPendar(
                          warna: warnaGelar,
                          isCircle: true,
                          borderRadius: 0,
                          borderWidth: 3.0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [warnaGelar, AppColors.primary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: warnaGelar.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: AppColors.background,
                              child: Text(
                                playerName.isNotEmpty ? playerName[0].toUpperCase() : 'P',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: warnaGelar,
                                ),
                              ),
                            ),
                          ),
                        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 16),
                        Text(
                          playerName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 8),
                        AnimasiPendar(
                          warna: warnaGelar,
                          borderRadius: 20,
                          borderWidth: 2.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: warnaGelar.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.workspace_premium_rounded, color: warnaGelar, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  gelar,
                                  style: TextStyle(
                                    color: warnaGelar,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: 350.ms),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Statistik Card
                  AnimasiPendar(
                    warna: warnaGelar,
                    borderRadius: 24,
                    borderWidth: 2.0,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'STATISTIK',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildStatRow(
                          context,
                          icon: Icons.stars_rounded,
                          iconColor: AppColors.gold,
                          label: 'Total Bintang',
                          value: '$totalStars ⭐',
                        ),
                        Divider(color: Colors.black.withValues(alpha: 0.06), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.mosque_rounded,
                          iconColor: const Color(0xFF16A34A),
                          label: 'Agama Islam',
                          value: '${progress.islamicSolved} / 100',
                        ),
                        Divider(color: Colors.black.withValues(alpha: 0.06), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.language_rounded,
                          iconColor: AppColors.primary,
                          label: 'Bahasa Indonesia',
                          value: '$bindoSolved / 100',
                        ),
                        Divider(color: Colors.black.withValues(alpha: 0.06), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.calculate_rounded,
                          iconColor: AppColors.success,
                          label: 'Matematika',
                          value: '$mathSolved / 100',
                        ),
                        Divider(color: Colors.black.withValues(alpha: 0.06), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.science_rounded,
                          iconColor: const Color(0xFFDC2626),
                          label: 'IPA',
                          value: '${progress.ipaSolved} / 100',
                        ),
                        Divider(color: Colors.black.withValues(alpha: 0.06), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.public_rounded,
                          iconColor: const Color(0xFFD97706),
                          label: 'IPS',
                          value: '${progress.ipsSolved} / 100',
                        ),
                        Divider(color: Colors.black.withValues(alpha: 0.06), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.balance_rounded,
                          iconColor: const Color(0xFFE11D48),
                          label: 'PPKn',
                          value: '${progress.ppknSolved} / 100',
                        ),
                        Divider(color: Colors.black.withValues(alpha: 0.06), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.menu_book_rounded,
                          iconColor: const Color(0xFF0284C7),
                          label: 'Bahasa Inggris',
                          value: '${progress.englishSolved} / 100',
                        ),
                      ],
                    ),
                    ),
                  ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 120), // Ekstra padding untuk navigasi
                ]),
              ),
            ),
          ],
        ),
      ), // Expanded
          ],
        ), // Column
      ), // SafeArea
    ); // Scaffold
  }

  Widget _buildStatRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
