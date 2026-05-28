import 'package:quiz/inti/utils/audio_helper.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/penyedia/penyedia_tema.dart';
import '../progres/penyedia_progres.dart';
import '../pengaturan/layar_pengaturan.dart';
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
    _loadPlayerName();
  }

  @override
  void dispose() {
    _navAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('player_name') ?? 'Pemain';
    ref.read(playerNameProvider.notifier).state = name;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(temaProvider);
    final progress = ref.watch(progressProvider);
    final isDark = appTheme == AppThemeMode.dark;
    final isComputer = appTheme == AppThemeMode.computer;

    // Pilih warna latar sesuai mode
    final bgColor = isDark
        ? AppColors.background
        : isComputer
            ? AppColors.backgroundComputer
            : AppColors.backgroundLightBlue;
    final bgGradient = isDark
        ? AppColors.backgroundGradient
        : isComputer
            ? AppColors.backgroundComputerGradient
            : AppColors.backgroundLightGradient;

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
            child: _buildFloatingBottomNav(isDark, isComputer, progress.warnaGelar),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNav(bool isDark, bool isComputer, Color warnaGelar) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: AnimasiPendar(
            warna: warnaGelar,
            borderRadius: isComputer ? 4 : 32,
            borderWidth: 2.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isComputer ? 4 : 32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                  color: isComputer
                      ? AppColors.surfaceComputer.withValues(alpha: 0.95)
                      : isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.8)
                          : AppColors.surfaceLightBlue.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(isComputer ? 4 : 32),
                  boxShadow: isComputer
                      ? AppColors.computerCardShadow
                      : [
                          BoxShadow(
                            color: isDark
                                ? AppColors.primary.withValues(alpha: 0.2)
                                : AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Beranda', isDark, isComputer),
                    _buildNavItem(1, Icons.person_rounded, Icons.person_outline_rounded, 'Profil', isDark, isComputer),
                    _buildNavItem(2, Icons.settings_rounded, Icons.settings_outlined, 'Pengaturan', isDark, isComputer),
                  ],
                ),
              ),
            ),
          ).animate().slideY(begin: 1, end: 0, duration: 600.ms, curve: Curves.easeOutBack),
        ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, bool isDark, bool isComputer) {
    final isActive = _currentIndex == index;
    final inactiveColor = isDark
        ? AppColors.textSecondary
        : isComputer
            ? AppColors.textSecondaryComputer
            : AppColors.textSecondaryLightBlue;
    final gradient = isComputer
        ? AppColors.primaryComputerGradient
        : AppColors.buttonGradient;
    final glow = isComputer ? AppColors.computerShadow : (isDark ? AppColors.primaryGlow : AppColors.lightBlueGlow);

    return GestureDetector(
      onTap: () {
AudioHelper.playClick();
        if (_currentIndex != index) {
          setState(() => _currentIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isActive ? 24 : 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive ? gradient : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(isComputer ? 4 : 24),
          boxShadow: isActive ? glow : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? Colors.white : inactiveColor,
              size: 24,
            ).animate(target: isActive ? 1 : 0)
             .scaleXY(begin: 0.8, end: 1.1, duration: 200.ms)
             .then().scaleXY(end: 1.0, duration: 200.ms),
             
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ).animate().fadeIn(duration: 200.ms).slideX(begin: -0.2, end: 0, duration: 200.ms),
            ],
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
    final appTheme = ref.watch(temaProvider);
    final isDark = appTheme == AppThemeMode.dark;
    final isComputer = appTheme == AppThemeMode.computer;

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by Stack in MainNavigationScreen
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header TETAP DI ATAS - tidak ikut scroll
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: ShaderMask(
                shaderCallback: (bounds) => (isComputer ? AppColors.primaryComputerGradient : AppColors.primaryGradient).createShader(bounds),
                child: const Text(
                  'Profil',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms),
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
                      color: isDark ? AppColors.surfaceLight.withValues(alpha: 0.6) : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightModeSecond.withValues(alpha: 0.8)),
                      borderRadius: BorderRadius.circular(isComputer ? 4 : 28),
                      border: Border.all(color: isComputer ? AppColors.surfaceComputerBorder : warnaGelar.withValues(alpha: 0.3), width: 1.5),
                      boxShadow: isComputer ? AppColors.computerCardShadow : [
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
                          isCircle: !isComputer,
                          borderRadius: isComputer ? 8 : 0,
                          borderWidth: 3.0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: isComputer ? BoxShape.rectangle : BoxShape.circle,
                              borderRadius: isComputer ? BorderRadius.circular(8) : null,
                              gradient: isComputer ? AppColors.primaryComputerGradient : LinearGradient(
                                colors: [warnaGelar, AppColors.primary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: isComputer ? AppColors.computerShadow : [
                                BoxShadow(
                                  color: warnaGelar.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: isDark ? AppColors.background : (isComputer ? AppColors.backgroundComputer : AppColors.backgroundLight),
                              child: Text(
                                playerName.isNotEmpty ? playerName[0].toUpperCase() : 'P',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: isComputer ? AppColors.textPrimaryComputer : warnaGelar,
                                ),
                              ),
                            ),
                          ),
                        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 16),
                        Text(
                          playerName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : (isComputer ? AppColors.textPrimaryComputer : AppColors.textPrimaryLight),
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 8),
                        AnimasiPendar(
                          warna: warnaGelar,
                          borderRadius: isComputer ? 4 : 20,
                          borderWidth: 2.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isComputer ? AppColors.surfaceComputerSecond : warnaGelar.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(isComputer ? 4 : 20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.workspace_premium_rounded, color: warnaGelar, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  gelar,
                                  style: TextStyle(
                                    color: isComputer ? AppColors.textSecondaryComputer : warnaGelar,
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
                    borderRadius: isComputer ? 4 : 24,
                    borderWidth: 2.0,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceLight.withValues(alpha: 0.6) : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightModeSecond.withValues(alpha: 0.8)),
                        borderRadius: BorderRadius.circular(isComputer ? 4 : 24),
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
                          iconColor: isComputer ? AppColors.primaryComputerLight : AppColors.gold,
                          label: 'Total Bintang',
                          value: '$totalStars ⭐',
                          isDark: isDark,
                          isComputer: isComputer,
                        ),
                        Divider(color: isDark ? Colors.white.withValues(alpha: 0.06) : (isComputer ? AppColors.surfaceComputerBorder : Colors.black.withValues(alpha: 0.06)), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.mosque_rounded,
                          iconColor: isComputer ? AppColors.primaryComputerLight : const Color(0xFF16A34A),
                          label: 'Agama Islam',
                          value: '${progress.islamicSolved} / 100',
                          isDark: isDark,
                          isComputer: isComputer,
                        ),
                        Divider(color: isDark ? Colors.white.withValues(alpha: 0.06) : (isComputer ? AppColors.surfaceComputerBorder : Colors.black.withValues(alpha: 0.06)), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.language_rounded,
                          iconColor: isComputer ? AppColors.primaryComputerLight : AppColors.primary,
                          label: 'Bahasa Indonesia',
                          value: '$bindoSolved / 100',
                          isDark: isDark,
                          isComputer: isComputer,
                        ),
                        Divider(color: isDark ? Colors.white.withValues(alpha: 0.06) : (isComputer ? AppColors.surfaceComputerBorder : Colors.black.withValues(alpha: 0.06)), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.calculate_rounded,
                          iconColor: isComputer ? AppColors.primaryComputerLight : AppColors.success,
                          label: 'Matematika',
                          value: '$mathSolved / 100',
                          isDark: isDark,
                          isComputer: isComputer,
                        ),
                        Divider(color: isDark ? Colors.white.withValues(alpha: 0.06) : (isComputer ? AppColors.surfaceComputerBorder : Colors.black.withValues(alpha: 0.06)), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.science_rounded,
                          iconColor: isComputer ? AppColors.primaryComputerLight : const Color(0xFFDC2626),
                          label: 'IPA',
                          value: '${progress.ipaSolved} / 100',
                          isDark: isDark,
                          isComputer: isComputer,
                        ),
                        Divider(color: isDark ? Colors.white.withValues(alpha: 0.06) : (isComputer ? AppColors.surfaceComputerBorder : Colors.black.withValues(alpha: 0.06)), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.public_rounded,
                          iconColor: isComputer ? AppColors.primaryComputerLight : const Color(0xFFD97706),
                          label: 'IPS',
                          value: '${progress.ipsSolved} / 100',
                          isDark: isDark,
                          isComputer: isComputer,
                        ),
                        Divider(color: isDark ? Colors.white.withValues(alpha: 0.06) : (isComputer ? AppColors.surfaceComputerBorder : Colors.black.withValues(alpha: 0.06)), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.balance_rounded,
                          iconColor: isComputer ? AppColors.primaryComputerLight : const Color(0xFFE11D48),
                          label: 'PPKn',
                          value: '${progress.ppknSolved} / 100',
                          isDark: isDark,
                          isComputer: isComputer,
                        ),
                        Divider(color: isDark ? Colors.white.withValues(alpha: 0.06) : (isComputer ? AppColors.surfaceComputerBorder : Colors.black.withValues(alpha: 0.06)), height: 28),
                        _buildStatRow(
                          context,
                          icon: Icons.menu_book_rounded,
                          iconColor: isComputer ? AppColors.primaryComputerLight : const Color(0xFF0284C7),
                          label: 'Bahasa Inggris',
                          value: '${progress.englishSolved} / 100',
                          isDark: isDark,
                          isComputer: isComputer,
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
    required bool isDark,
    required bool isComputer,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(isComputer ? 4 : 12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Text(label, style: TextStyle(color: isDark ? AppColors.textSecondary : (isComputer ? AppColors.textSecondaryComputer : AppColors.textSecondaryLight), fontSize: 14, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : (isComputer ? AppColors.textPrimaryComputer : AppColors.textPrimaryLight),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
