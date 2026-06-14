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

  // ─── Dialog Ubah Nama ─────────────────────────────────────────────
  void _tampilkanDialogUbahNama() {
    final playerName = ref.read(playerNameProvider);
    final controller = TextEditingController(text: playerName);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        title: const Text('Ubah Nama Pemain',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            maxLength: 15,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
              hintText: 'Nama baru...',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Nama tidak boleh kosong!';
              if (v.trim().length < 3) return 'Minimal 3 karakter!';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () { AudioHelper.playClick(); Navigator.of(context).pop(); }, child: const Text('Batal', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              AudioHelper.playClick();
              if (!formKey.currentState!.validate()) return;
              final newName = controller.text.trim();
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('player_name', newName);
              ref.read(playerNameProvider.notifier).state = newName;
              if (context.mounted) {
                Navigator.of(context).pop();
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
        child: SafeArea(
          child: Column(
            children: [
              // Header (Fixed/Sticky)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                      child: const Text('Pengaturan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                    const Spacer(),
                    const Icon(Icons.settings_outlined, color: AppColors.primary, size: 28),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
              
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(24),
                      sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    // ── PROFIL ─────────────────────────────────────────
                    _buildLabel('Profil', Icons.person_outline, AppColors.primary),
                    const SizedBox(height: 30), // Ruang ekstra untuk avatar melayang
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        // Lapis Bawah: Card
                        Container(
                          margin: const EdgeInsets.only(top: 36),
                          child: _buildGlassCard(
                            color: AppColors.surface, divColor: Colors.black12, glowColor: progress.warnaGelar,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 48, 20, 20), // Padding atas besar untuk avatar
                              child: Column(
                                children: [
                                  Text(
                                    playerName,
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    progress.gelarKecerdasan,
                                    style: TextStyle(fontSize: 14, color: progress.warnaGelar, fontWeight: FontWeight.bold, letterSpacing: 1),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          const Text('Bintang', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
                                              const SizedBox(width: 4),
                                              Text('${progress.totalStars}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 32),
                                      Container(width: 1, height: 30, color: Colors.black12),
                                      const SizedBox(width: 32),
                                      Column(
                                        children: [
                                          const Text('Level Max', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.workspace_premium_rounded, color: AppColors.accent, size: 18),
                                              const SizedBox(width: 4),
                                              Text('${progress.totalStars > 0 ? (progress.totalStars / 3).floor() : 0}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () { AudioHelper.playClick(); _tampilkanDialogUbahNama(); },
                                      icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
                                      label: const Text('Ubah Nama', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: progress.warnaGelar,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Lapis Atas: Avatar Melayang (Menonjol keluar dari card)
                        Positioned(
                          top: 0,
                          child: AnimasiPendar(
                            warna: progress.warnaGelar,
                            isCircle: true,
                            borderWidth: 4.0,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.primaryGradient,
                                boxShadow: AppColors.primaryGlow,
                                border: Border.all(color: AppColors.surface, width: 4),
                              ),
                              child: Center(
                                child: Text(
                                  playerName.isNotEmpty ? playerName[0].toUpperCase() : 'P',
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                                ),
                              ),
                            ),
                          ).animate().scale(delay: 200.ms, curve: Curves.elasticOut, duration: 800.ms),
                        ),
                      ],
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 36),

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
            ),
          ],
        ),
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
