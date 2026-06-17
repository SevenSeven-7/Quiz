import 'package:quiz/inti/utils/audio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../progres/penyedia_progres.dart';
import '../beranda/layar_utama.dart';
import '../splash/layar_buat_nama.dart';
import '../../inti/widget/animasi_pendar.dart';
import '../../inti/widget/wave_clipper.dart';

class LayarPengaturan extends ConsumerStatefulWidget {
  const LayarPengaturan({super.key});

  @override
  ConsumerState<LayarPengaturan> createState() => _LayarPengaturanState();
}

class _LayarPengaturanState extends ConsumerState<LayarPengaturan> {
  bool _suaraAktif = true;
  bool _notifikasiAktif = true;
  final String _versiAplikasi = '1.1.0';

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
    AudioHelper.updateSoundPreference(nilai);
    setState(() => _suaraAktif = nilai);
  }

  Future<void> _simpanNotifikasi(bool nilai) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pengaturan_notifikasi', nilai);
    setState(() => _notifikasiAktif = nilai);
  }

  // ─── Dialog Hapus Akun ────────────────────────────────────────────
  void _tampilkanDialogHapusAkun() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: AppColors.failure.withValues(alpha: 0.4)),
        ),
        title: const Text('Hapus Akun', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.failure)),
        content: const Text('Semua data progres, bintang, dan pencapaian kamu akan terhapus permanen.\n\nApakah kamu yakin?', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(onPressed: () { AudioHelper.playClick(); Navigator.of(context).pop(); }, child: const Text('Batal', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              AudioHelper.playClick();
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              ref.read(playerNameProvider.notifier).state = '';
              ref.read(progressProvider.notifier).resetProgress();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LayarBuatNama()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.failure,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Sheet Deskripsi Aplikasi ─────────────────────────────
  void _tampilkanDeskripsiAplikasi() {
    final mataPelajaran = [
      'Bahasa Indonesia', 'Matematika', 'Ilmu Pengetahuan Alam (IPA)',
      'Ilmu Pengetahuan Sosial (IPS)', 'PPKn', 'Bahasa Inggris',
      'Sejarah', 'Teknologi & Informatika (TIK)', 'Agama Islam'
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final maxH = MediaQuery.of(context).size.height * 0.85;
        return Container(
          constraints: BoxConstraints(maxHeight: maxH),
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
            border: Border(top: BorderSide(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),

              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle,
                          boxShadow: AppColors.primaryGlow),
                        child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 16),
                      ShaderMask(
                        shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                        child: const Text('Quiz', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                      ),
                      const SizedBox(height: 8),
                      Text('Versi $_versiAplikasi', style: TextStyle(color: AppColors.primary.withValues(alpha: 0.7), fontSize: 13)),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                        ),
                        child: const Text(
                          'Quiz adalah aplikasi pembelajaran interaktif berbasis Kurikulum Merdeka dan K-13. Pemain dapat memilih berbagai mata pelajaran mulai dari Agama Islam, Bahasa Indonesia, Matematika, IPA, IPS, PPKn, hingga Bahasa Inggris.\n\nCara Kerja:\n• Jawab soal dengan benar untuk mengumpulkan Bintang ⭐.\n• Semakin banyak bintang, Anda akan mendapatkan Gelar Pangkat yang lebih tinggi (Pemula → Legenda) dan membuka level baru.\n• Desain elegan dengan efek suara interaktif untuk pengalaman belajar yang seru!',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('MATA PELAJARAN TERSEDIA',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1.5)),
                      ),
                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: mataPelajaran.map((mp) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20)),
                          child: Text(mp, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        )).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Tombol Tutup selalu di bawah
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () { AudioHelper.playClick(); Navigator.pop(context); }, style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Tutup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Build ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final playerName = ref.watch(playerNameProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            // 1. Konten yang bisa di-scroll (berada di belakang)
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Ruang kosong sebesar tinggi header
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.top + 98),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([

                    // ── SUARA & TAMPILAN ──────────────────────────────
                    _buildLabel('Suara & Tampilan', Icons.tune_outlined, AppColors.primary),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      color: AppColors.surface, divColor: Colors.black12, glowColor: progress.warnaGelar,
                      child: Column(children: [
                        _buildToggle(icon: Icons.volume_up_outlined, iconColor: AppColors.accent, label: 'Efek Suara', subtitle: 'Aktifkan efek suara saat menjawab soal', value: _suaraAktif, onChanged: _simpanSuara),
                        const Divider(color: Colors.black12, height: 1),
                        _buildToggle(icon: Icons.notifications_outlined, iconColor: AppColors.gold, label: 'Notifikasi', subtitle: 'Terima pengingat belajar harian', value: _notifikasiAktif, onChanged: _simpanNotifikasi),
                      ]),
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 28),

                    // ── DATA & AKUN ───────────────────────────────────
                    _buildLabel('Data & Akun', Icons.shield_outlined, AppColors.primary),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      color: AppColors.surface, divColor: Colors.black12, glowColor: progress.warnaGelar,
                      child: _buildAction(
                        icon: Icons.delete_forever_rounded,
                        iconColor: AppColors.failure,
                        label: 'Hapus Akun',
                        subtitle: 'Hapus semua data akun secara permanen',
                        onTap: () { AudioHelper.playClick(); _tampilkanDialogHapusAkun(); },
                        isDestructive: true,
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 28),

                    // ── TENTANG APLIKASI ──────────────────────────────
                    _buildLabel('Tentang Aplikasi', Icons.info_outline, AppColors.primary),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      color: AppColors.surface, divColor: Colors.black12, glowColor: progress.warnaGelar,
                      child: _buildAction(
                        icon: Icons.quiz_outlined,
                        iconColor: AppColors.primary,
                        label: 'Deskripsi Aplikasi',
                        subtitle: 'Pelajari tentang Quiz App lebih lanjut',
                        onTap: () { AudioHelper.playClick(); _tampilkanDeskripsiAplikasi(); },
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 32),
                    const Center(
                      child: Text('Quiz App · v1.1.0',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 1)),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 120),
                    ]),
                  ),
                ),
              ],
            ),
            
            // 2. Header Wave (di atas)
            Positioned(
              top: 0, left: 0, right: 0,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    bottom: 50,
                    left: 24,
                    right: 24,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Pengaturan',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      const Spacer(),
                      const Icon(Icons.settings_outlined, color: Colors.white, size: 28),
                    ],
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Widget Helpers ───────────────────────────────────────────────
  Widget _buildLabel(String label, IconData icon, Color color) {
    return Row(children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 8),
      Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color, letterSpacing: 1.5)),
    ]);
  }

  Widget _buildGlassCard({required Widget child, required Color color, required Color divColor, required Color glowColor}) {
    return AnimasiPendar(
      warna: glowColor,
      borderRadius: 20,
      borderWidth: 2.0,
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20), boxShadow: AppColors.cardShadow),
        child: ClipRRect(borderRadius: BorderRadius.circular(20), child: child),
      ),
    );
  }

  Widget _buildToggle({
    required IconData icon, required Color iconColor, required String label, required String subtitle,
    required bool value, required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 22)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ])),
        Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
      ]),
    );
  }

  Widget _buildAction({
    required IconData icon, required Color iconColor, required String label, required String subtitle,
    required VoidCallback onTap, bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 22)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(color: isDestructive ? AppColors.failure : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ])),
          const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
        ]),
      ),
    );
  }
}
