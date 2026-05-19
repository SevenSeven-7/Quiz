import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../progres/penyedia_progres.dart';
import '../beranda/layar_utama.dart';

// Layar Pengaturan lengkap dengan desain glassmorphism premium
class LayarPengaturan extends ConsumerStatefulWidget {
  const LayarPengaturan({super.key});

  @override
  ConsumerState<LayarPengaturan> createState() => _LayarPengaturanState();
}

class _LayarPengaturanState extends ConsumerState<LayarPengaturan> {
  bool _suaraAktif = true;
  bool _notifikasiAktif = true;
  String _versiAplikasi = '1.0.0';

  @override
  void initState() {
    super.initState();
    _muatPengaturan();
  }

  Future<void> _muatPengaturan() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _suaraAktif = prefs.getBool('pengaturan_suara') ?? true;
      _notifikasiAktif = prefs.getBool('pengaturan_notifikasi') ?? true;
    });
  }

  Future<void> _simpanSuara(bool nilai) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pengaturan_suara', nilai);
    setState(() => _suaraAktif = nilai);
  }

  Future<void> _simpanNotifikasi(bool nilai) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pengaturan_notifikasi', nilai);
    setState(() => _notifikasiAktif = nilai);
  }

  void _tampilkanDialogResetProgres() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.failure.withOpacity(0.5), width: 1.5),
        ),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.failure.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AppColors.failure, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'Reset Semua Progres?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Seluruh bintang, level yang terbuka, dan pencapaian Anda akan dihapus secara permanen. Tindakan ini tidak dapat dibatalkan!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Batal', style: TextStyle(color: Colors.white70)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref.read(progressProvider.notifier).resetProgress();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.failure,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Progres berhasil direset!', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.failure,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Ya, Reset!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [],
      ),
    );
  }

  void _tampilkanDialogUbahNama() {
    final playerName = ref.read(playerNameProvider);
    final controller = TextEditingController(text: playerName);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
        ),
        title: const Text(
          'Ubah Nama Pemain',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            maxLength: 15,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
              hintText: 'Nama baru...',
              hintStyle: const TextStyle(color: Colors.grey),
              counterStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Nama tidak boleh kosong!';
              if (v.trim().length < 3) return 'Minimal 3 karakter!';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final newName = controller.text.trim();
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('player_name', newName);
              ref.read(playerNameProvider.notifier).state = newName;
              await ref.read(progressProvider.notifier).syncWithFirebase(newName);
              if (context.mounted) {
                Navigator.of(context).pop();
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerName = ref.watch(playerNameProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // AppBar premium
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                        child: const Text(
                          'Pengaturan',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.settings_outlined, color: AppColors.primary, size: 28),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Kartu Profil
                    _buildSectionLabel('Profil', Icons.person_outline),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      child: InkWell(
                        onTap: _tampilkanDialogUbahNama,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.primaryGradient,
                                  boxShadow: AppColors.primaryGlow,
                                ),
                                child: Center(
                                  child: Text(
                                    playerName.isNotEmpty ? playerName[0].toUpperCase() : 'P',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      playerName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      progress.gelarKecerdasan,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: progress.warnaGelar,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                ),
                                child: const Text(
                                  'Ubah',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 28),

                    // Kartu Suara & Tampilan
                    _buildSectionLabel('Suara & Tampilan', Icons.tune_outlined),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      child: Column(
                        children: [
                          _buildToggleItem(
                            icon: Icons.volume_up_outlined,
                            iconColor: AppColors.accent,
                            label: 'Efek Suara',
                            subtitle: 'Aktifkan suara saat menjawab soal',
                            value: _suaraAktif,
                            onChanged: _simpanSuara,
                          ),
                          Divider(color: Colors.white.withOpacity(0.06), height: 1),
                          _buildToggleItem(
                            icon: Icons.notifications_outlined,
                            iconColor: AppColors.gold,
                            label: 'Notifikasi',
                            subtitle: 'Terima pengingat belajar harian',
                            value: _notifikasiAktif,
                            onChanged: _simpanNotifikasi,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 28),

                    // Kartu Data
                    _buildSectionLabel('Data & Privasi', Icons.shield_outlined),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      child: _buildActionItem(
                        icon: Icons.delete_sweep_outlined,
                        iconColor: AppColors.failure,
                        label: 'Reset Semua Progres',
                        subtitle: 'Hapus seluruh bintang dan level yang telah dibuka',
                        onTap: _tampilkanDialogResetProgres,
                        isDestructive: true,
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 28),

                    // Kartu Tentang
                    _buildSectionLabel('Tentang Aplikasi', Icons.info_outline),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      child: Column(
                        children: [
                          _buildInfoItem(
                            icon: Icons.quiz_outlined,
                            iconColor: AppColors.primary,
                            label: 'Nama Aplikasi',
                            value: 'Quiz',
                          ),
                          Divider(color: Colors.white.withOpacity(0.06), height: 1),
                          _buildInfoItem(
                            icon: Icons.tag,
                            iconColor: AppColors.accent,
                            label: 'Versi',
                            value: _versiAplikasi,
                          ),
                          Divider(color: Colors.white.withOpacity(0.06), height: 1),
                          _buildInfoItem(
                            icon: Icons.star_outline,
                            iconColor: AppColors.gold,
                            label: 'Total Bintang',
                            value: '${progress.totalStars} ⭐',
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 32),

                    // Label kredit di bawah
                    Center(
                      child: Text(
                        'Quiz App · v$_versiAplikasi',
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.4),
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.3),
            inactiveTrackColor: Colors.white12,
            inactiveThumbColor: Colors.white38,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isDestructive ? AppColors.failure : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
