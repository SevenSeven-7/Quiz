import 'package:quiz/inti/utils/audio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/penyedia/penyedia_tema.dart';
import '../progres/penyedia_progres.dart';
import '../beranda/layar_utama.dart';
import '../splash/layar_buat_nama.dart';

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
    final currentMode = ref.read(temaProvider);
    final isDark = currentMode == AppThemeMode.dark;
    final isComputer = currentMode == AppThemeMode.computer;
    final accentColor = isComputer ? AppColors.primaryComputer : AppColors.primary;
    final borderRadius = isComputer ? 4.0 : 24.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: accentColor.withValues(alpha: 0.4)),
        ),
        title: Text('Ubah Nama Pemain',
            style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : (isComputer ? AppColors.textPrimaryComputer : AppColors.textPrimaryLightBlue))),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            maxLength: 15,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline, color: accentColor),
              hintText: 'Nama baru...',
              filled: true,
              fillColor: isDark ? AppColors.background : (isComputer ? AppColors.backgroundComputer : AppColors.backgroundLightBlue),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(isComputer ? 4.0 : 12.0), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(isComputer ? 4.0 : 12.0), borderSide: BorderSide(color: accentColor, width: 1.5)),
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
              // Progress sudah otomatis tersimpan lokal
              if (context.mounted) {
                Navigator.of(context).pop();
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isComputer ? 4.0 : 12.0)),
            ),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Dialog Hapus Akun ────────────────────────────────────────────
  void _tampilkanDialogHapusAkun() {
    final currentMode = ref.read(temaProvider);
    final isDark = currentMode == AppThemeMode.dark;
    final isComputer = currentMode == AppThemeMode.computer;
    final borderRadius = isComputer ? 4.0 : 24.0;
    final btnRadius = isComputer ? 4.0 : 12.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: AppColors.failure.withValues(alpha: 0.4)),
        ),
        title: const Text('Hapus Akun', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.failure)),
        content: const Text('Semua data progres, bintang, dan pencapaian kamu akan terhapus permanen.\n\nApakah kamu yakin?'),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(btnRadius)),
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
    final currentMode = ref.read(temaProvider);
    final isDark = currentMode == AppThemeMode.dark;
    final isComputer = currentMode == AppThemeMode.computer;
    final bgColor = isDark ? AppColors.surface : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightBlue);
    final accentColor = isComputer ? AppColors.primaryComputer : AppColors.primary;
    final accentGradient = isComputer ? AppColors.primaryComputerGradient : AppColors.primaryGradient;
    final borderRadius = isComputer ? 4.0 : 32.0;

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
            color: bgColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
            border: Border(top: BorderSide(color: accentColor.withValues(alpha: 0.3), width: 1.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(isComputer ? 0 : 2))),
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
                        decoration: BoxDecoration(gradient: accentGradient, shape: isComputer ? BoxShape.rectangle : BoxShape.circle, borderRadius: isComputer ? BorderRadius.circular(8) : null,
                          boxShadow: isComputer ? AppColors.computerShadow : AppColors.primaryGlow),
                        child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 16),
                      ShaderMask(
                        shaderCallback: (b) => accentGradient.createShader(b),
                        child: const Text('Quiz', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                      ),
                      const SizedBox(height: 8),
                      Text('Versi $_versiAplikasi', style: TextStyle(color: accentColor.withValues(alpha: 0.7), fontSize: 13)),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(isComputer ? 4 : 16),
                          border: Border.all(color: accentColor.withValues(alpha: 0.15)),
                        ),
                        child: const Text(
                          'Quiz adalah aplikasi pembelajaran interaktif berbasis Kurikulum Merdeka dan K-13. Pemain dapat memilih berbagai mata pelajaran mulai dari Matematika, IPA, hingga Sejarah.\n\nCara Kerja:\n• Jawab soal dengan benar untuk mengumpulkan Bintang ⭐.\n• Semakin banyak bintang, Anda akan mendapatkan Pangkat Kecerdasan yang lebih tinggi (Pemula → Jenius) dan membuka level baru.\n• Terdapat 3 pilihan tema (Gelap / Terang / Komputer) serta efek suara interaktif untuk pengalaman belajar yang seru!',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 13, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('MATA PELAJARAN TERSEDIA',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: accentColor, letterSpacing: 1.5)),
                      ),
                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: mataPelajaran.map((mp) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(gradient: accentGradient, borderRadius: BorderRadius.circular(isComputer ? 4 : 20)),
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
                      backgroundColor: accentColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isComputer ? 4 : 14)),
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
    final currentThemeMode = ref.watch(temaProvider);
    final isDark = currentThemeMode == AppThemeMode.dark;
    final isComputer = currentThemeMode == AppThemeMode.computer;

    final bgGradient = isDark
        ? AppColors.backgroundGradient
        : isComputer
            ? AppColors.backgroundComputerGradient
            : AppColors.backgroundLightGradient;
    final cardColor = isDark
        ? AppColors.surfaceLight.withValues(alpha: 0.6)
        : isComputer
            ? AppColors.surfaceComputer
            : AppColors.surfaceLightBlueSecond.withValues(alpha: 0.8);
    final labelColor = isComputer ? AppColors.primaryComputer : AppColors.primary;
    final textColor = isDark ? Colors.white : (isComputer ? AppColors.textPrimaryComputer : AppColors.textPrimaryLightBlue);
    final subTextColor = isDark ? AppColors.textSecondary : (isComputer ? AppColors.textSecondaryComputer : AppColors.textSecondaryLightBlue);
    final divColor = isDark ? Colors.white.withValues(alpha: 0.06) : (isComputer ? AppColors.surfaceComputerBorder : Colors.black.withValues(alpha: 0.06));
    final headerGradient = isComputer ? AppColors.primaryComputerGradient : AppColors.primaryGradient;

    final soundIconColor = isComputer ? AppColors.primaryComputerLight : AppColors.accent;
    final notifIconColor = isComputer ? AppColors.primaryComputerLight : AppColors.gold;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header (Fixed/Sticky)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => headerGradient.createShader(b),
                      child: const Text('Pengaturan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                    const Spacer(),
                    Icon(Icons.settings_outlined, color: labelColor, size: 28),
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
                    _buildLabel('Profil', Icons.person_outline, labelColor),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      color: cardColor, divColor: divColor, isComputer: isComputer,
                      child: InkWell(
                        onTap: () { AudioHelper.playClick(); _tampilkanDialogUbahNama(); },
                        borderRadius: BorderRadius.circular(isComputer ? 4 : 20),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 56, height: 56,
                                decoration: BoxDecoration(
                                  shape: isComputer ? BoxShape.rectangle : BoxShape.circle,
                                  borderRadius: isComputer ? BorderRadius.circular(8) : null,
                                  gradient: isComputer ? AppColors.primaryComputerGradient : AppColors.primaryGradient,
                                  boxShadow: isComputer ? AppColors.computerShadow : AppColors.primaryGlow,
                                ),
                                child: Center(child: Text(
                                  playerName.isNotEmpty ? playerName[0].toUpperCase() : 'P',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                )),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(playerName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                                  const SizedBox(height: 4),
                                  Text(progress.gelarKecerdasan, style: TextStyle(fontSize: 13, color: isComputer ? AppColors.accentComputer : progress.warnaGelar, fontWeight: FontWeight.w600)),
                                ]),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: labelColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(isComputer ? 4 : 20),
                                  border: Border.all(color: labelColor.withValues(alpha: 0.3)),
                                ),
                                child: Text('Ubah Nama', style: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 28),

                    // ── SUARA & TAMPILAN ──────────────────────────────
                    _buildLabel('Suara & Tampilan', Icons.tune_outlined, labelColor),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      color: cardColor, divColor: divColor, isComputer: isComputer,
                      child: Column(children: [
                        _buildToggle(icon: Icons.volume_up_outlined, iconColor: soundIconColor, label: 'Efek Suara', subtitle: 'Aktifkan suara saat menjawab soal', value: _suaraAktif, onChanged: _simpanSuara, textColor: textColor, subTextColor: subTextColor, isComputer: isComputer),
                        Divider(color: divColor, height: 1),
                        _buildToggle(icon: Icons.notifications_outlined, iconColor: notifIconColor, label: 'Notifikasi', subtitle: 'Terima pengingat belajar harian', value: _notifikasiAktif, onChanged: _simpanNotifikasi, textColor: textColor, subTextColor: subTextColor, isComputer: isComputer),
                        Divider(color: divColor, height: 1),

                        // Tema Selector (3 Modes)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: labelColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(isComputer ? 4 : 12)),
                                    child: Icon(Icons.palette_outlined, color: labelColor, size: 22),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text('Tema Aplikasi', style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 15)),
                                      const SizedBox(height: 2),
                                      Text('Pilih mode tampilan', style: TextStyle(color: subTextColor, fontSize: 12)),
                                    ]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surface : (isComputer ? AppColors.surfaceComputerSecond : AppColors.backgroundLightBlue),
                                  borderRadius: BorderRadius.circular(isComputer ? 4 : 16),
                                  border: Border.all(color: divColor),
                                ),
                                child: Row(
                                  children: [
                                    _buildThemeOption('Komputer', Icons.computer_rounded, AppThemeMode.computer, currentThemeMode, textColor, isDark, isComputer),
                                    _buildThemeOption('Terang', Icons.light_mode_rounded, AppThemeMode.light, currentThemeMode, textColor, isDark, isComputer),
                                    _buildThemeOption('Gelap', Icons.dark_mode_rounded, AppThemeMode.dark, currentThemeMode, textColor, isDark, isComputer),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 28),

                    // ── DATA & AKUN ───────────────────────────────────
                    _buildLabel('Data & Akun', Icons.shield_outlined, labelColor),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      color: cardColor, divColor: divColor, isComputer: isComputer,
                      child: _buildAction(
                        icon: Icons.delete_forever_rounded,
                        iconColor: AppColors.failure,
                        label: 'Hapus Akun',
                        subtitle: 'Hapus semua data akun secara permanen',
                        onTap: () { AudioHelper.playClick(); _tampilkanDialogHapusAkun(); },
                        isDestructive: true,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        isComputer: isComputer,
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 28),

                    // ── TENTANG APLIKASI ──────────────────────────────
                    _buildLabel('Tentang Aplikasi', Icons.info_outline, labelColor),
                    const SizedBox(height: 10),
                    _buildGlassCard(
                      color: cardColor, divColor: divColor, isComputer: isComputer,
                      child: _buildAction(
                        icon: Icons.quiz_outlined,
                        iconColor: labelColor,
                        label: 'Deskripsi Aplikasi',
                        subtitle: 'Pelajari tentang Quiz App lebih lanjut',
                        onTap: () { AudioHelper.playClick(); _tampilkanDeskripsiAplikasi(); },
                        textColor: textColor,
                        subTextColor: subTextColor,
                        isComputer: isComputer,
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 32),
                    Center(
                      child: Text('Quiz App · v$_versiAplikasi',
                          style: TextStyle(color: subTextColor.withValues(alpha: 0.4), fontSize: 12, letterSpacing: 1)),
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

  Widget _buildThemeOption(String label, IconData icon, AppThemeMode mode, AppThemeMode currentMode, Color textColor, bool isDark, bool isComputer) {
    final isSelected = currentMode == mode;
    final activeColor = isComputer ? AppColors.primaryComputer : AppColors.primary;
    final inactiveTextColor = isDark ? Colors.white54 : (isComputer ? AppColors.textSecondaryComputer : Colors.black54);
    return Expanded(
      child: GestureDetector(
        onTap: () { AudioHelper.playClick(); ref.read(temaProvider.notifier).ubahTema(mode); }, child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(isComputer ? 4 : 12),
            boxShadow: isSelected
                ? (isDark ? AppColors.primaryGlow : (isComputer ? AppColors.computerShadow : AppColors.lightBlueGlow))
                : [],
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isSelected ? Colors.white : inactiveTextColor),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : inactiveTextColor,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, IconData icon, Color color) {
    return Row(children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 8),
      Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color, letterSpacing: 1.5)),
    ]);
  }

  Widget _buildGlassCard({required Widget child, required Color color, required Color divColor, required bool isComputer}) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(isComputer ? 4 : 20), border: Border.all(color: divColor, width: 1)),
      child: ClipRRect(borderRadius: BorderRadius.circular(isComputer ? 4 : 20), child: child),
    );
  }

  Widget _buildToggle({
    required IconData icon, required Color iconColor, required String label, required String subtitle,
    required bool value, required ValueChanged<bool> onChanged, required Color textColor, required Color subTextColor, required bool isComputer,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(isComputer ? 4 : 12)), child: Icon(icon, color: iconColor, size: 22)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(color: subTextColor, fontSize: 12)),
        ])),
        Switch(value: value, onChanged: onChanged),
      ]),
    );
  }

  Widget _buildAction({
    required IconData icon, required Color iconColor, required String label, required String subtitle,
    required VoidCallback onTap, bool isDestructive = false, required Color textColor, required Color subTextColor, required bool isComputer,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isComputer ? 4 : 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(isComputer ? 4 : 12)), child: Icon(icon, color: iconColor, size: 22)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(color: isDestructive ? AppColors.failure : textColor, fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: subTextColor, fontSize: 12)),
          ])),
          Icon(Icons.chevron_right, color: subTextColor.withValues(alpha: 0.4), size: 20),
        ]),
      ),
    );
  }
}
