import '../../inti/utils/audio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/layanan/layanan_data.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';
import 'layar_pilih_level.dart';
import 'layar_utama.dart';
import '../../inti/widget/wave_clipper.dart';
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. Konten yang bisa di-scroll (berada di belakang)
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Ruang kosong sebesar tinggi header agar konten mulai di bawah wave
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.top + 310),
              ),
              
              // Kategori label ikut ter-scroll
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
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
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Daftar Kategori
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                sliver: _buildPartList(context, ref, progress),
              ),
            ],
          ),

          // 2. Header Wave (di atas, menutupi konten saat discroll)
          Positioned(
            top: 0, left: 0, right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  bottom: 50,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context, playerName, progress),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildScoreCard(context, progress)
                          .animate()
                          .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutBack)
                          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 500.ms, curve: Curves.easeOutBack),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String playerName, ProgressState progress) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  playerName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
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
          ),
        ],
      ),
    );
  }

  LinearGradient _getRankGradient(String gelar) {
    if (gelar.contains('Pemula')) return AppColors.bronzeGradient;
    if (gelar.contains('Menengah')) return AppColors.silverGradient;
    if (gelar.contains('Ahli') || gelar.contains('Veteran')) return AppColors.goldGradient;
    if (gelar.contains('Master') || gelar.contains('Legenda')) return AppColors.legendGradient;
    return AppColors.buttonGradient;
  }

  Widget _buildScoreCard(BuildContext context, ProgressState progress) {
    final totalStars = progress.totalStars;
    final gelar = progress.gelarKecerdasan;
    final warnaGelar = progress.warnaGelar;
    const maxStars = 2100;
    final progressValue = (totalStars / maxStars).clamp(0.0, 1.0);
    final rankGradient = _getRankGradient(gelar);

    return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.95),
              warnaGelar.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                    const Text(
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
                          color: AppColors.textPrimary,
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
                  const Text(
                    'Menuju level berikutnya',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                  Text(
                    '${(progressValue * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: warnaGelar, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressValue,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: rankGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: warnaGelar.withValues(alpha: 0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartList(BuildContext context, WidgetRef ref, ProgressState progress) {
    return FutureBuilder<List<PartModel>>(
      future: DataService().getParts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: _buildShimmerLoading(),
          );
        }

        final parts = snapshot.data!;

        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.72, // Kartu vertikal (diperpanjang agar teks tidak terpotong)
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final part = parts[index];
              const isUnlocked = true;
              return _buildPartCard(context, part, isUnlocked, index);
            },
            childCount: parts.length,
          ),
        );
      },
    );
  }

  Widget _buildPartCard(BuildContext context, PartModel part, bool isUnlocked, int index) {
    // Nama khusus agar tampilannya selalu bersih dan tidak berubah-ubah
    final customNames = [
      'Agama Islam',
      'Bahasa Indonesia',
      'Matematika',
      'Ilmu Pengetahuan Alam',
      'Ilmu Pengetahuan Sosial',
      'Pendidikan Pancasila',
      'Bahasa Inggris'
    ];
    final String displayTitle = index < customNames.length ? customNames[index] : part.cleanTitle;

    // 7 Ikon spesifik untuk masing-masing mapel (tidak berulang)
    final icons = [
      Icons.mosque_rounded,        // Agama Islam
      Icons.language_rounded,      // Bahasa Indonesia
      Icons.calculate_rounded,     // Matematika
      Icons.science_rounded,       // IPA
      Icons.public_rounded,        // IPS
      Icons.balance_rounded,       // PPKn
      Icons.menu_book_rounded,     // Bahasa Inggris
    ];

    // 7 Warna spesifik yang sangat kontras dan tidak ada yang sama/mirip (Material Colors)
    final gradients = [
      [const Color(0xFF4CAF50), const Color(0xFF81C784)], // Hijau (Agama)
      [const Color(0xFF2196F3), const Color(0xFF64B5F6)], // Biru (B.Indo)
      [const Color(0xFFF44336), const Color(0xFFE57373)], // Merah (Matematika)
      [const Color(0xFF00BCD4), const Color(0xFF4DD0E1)], // Cyan (IPA)
      [const Color(0xFFFF9800), const Color(0xFFFFB74D)], // Oranye (IPS)
      [const Color(0xFF9C27B0), const Color(0xFFBA68C8)], // Ungu (PPKn)
      [const Color(0xFFE91E63), const Color(0xFFF06292)], // Pink (B.Inggris)
    ];
    
    final grad = gradients[index % gradients.length];
    final icon = icons[index % icons.length];

    // Bentukan organik asimetris
    final bool isLeft = index % 2 == 0;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(isLeft ? 40 : 16),
      topRight: Radius.circular(isLeft ? 16 : 40),
      bottomLeft: const Radius.circular(16),
      bottomRight: const Radius.circular(16),
    );

    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          borderRadius: borderRadius,
          border: Border.all(color: grad[0].withValues(alpha: 0.1), width: 1.5),
          gradient: isUnlocked ? LinearGradient(
            colors: [
              Colors.white,
              grad[0].withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ) : null,
          boxShadow: AppColors.cardShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isUnlocked
                ? () {
                    AudioHelper.playClick();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LevelSelectionScreen(part: part, categoryName: displayTitle, gradientColors: grad)),
                    );
                  }
                : null,
            borderRadius: borderRadius,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Kartu: Ikon & Arrow/Gembok
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: isUnlocked
                              ? LinearGradient(colors: grad, begin: Alignment.topLeft, end: Alignment.bottomRight)
                              : null,
                          color: isUnlocked ? null : Colors.black12,
                          shape: BoxShape.circle,
                          boxShadow: isUnlocked
                              ? [BoxShadow(color: grad[0].withValues(alpha: 0.3), blurRadius: 12)]
                              : null,
                        ),
                        child: Icon(
                          isUnlocked ? icon : Icons.lock_rounded,
                          color: isUnlocked ? Colors.white : Colors.black26,
                          size: 22,
                        ),
                      ),
                      if (isUnlocked)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: grad[0].withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_forward_rounded, color: grad[0], size: 16),
                        )
                      else
                        const Icon(Icons.lock_outline_rounded, color: Colors.black12, size: 20),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Teks Judul & Deskripsi
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      displayTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        color: isUnlocked ? AppColors.textPrimary : Colors.black38,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isUnlocked ? part.description : 'Selesaikan bagian sebelumnya',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.3,
                      color: AppColors.textSecondary.withValues(alpha: isUnlocked ? 1.0 : 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const MarqueeText({super.key, required this.text, required this.style});

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  double _textWidth = 0.0;
  bool _needsScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextWidth();
    });
  }

  void _checkTextWidth() {
    if (!mounted) return;
    
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final textPainter = TextPainter(
        text: TextSpan(text: widget.text, style: widget.style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      setState(() {
        _textWidth = textPainter.width;
        _needsScroll = _textWidth > renderBox.size.width;
      });

      if (_needsScroll) {
        _startScrolling(renderBox.size.width);
      }
    }
  }

  void _startScrolling(double containerWidth) {
    final distance = _textWidth - containerWidth + 20; // +20 padding ujung
    final duration = Duration(milliseconds: (distance * 30).toInt()); // kecepatan konstan
    
    _animationController.duration = duration;
    
    _animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _scrollController.jumpTo(0);
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            _animationController.forward(from: 0.0);
          }
        }
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _animationController.forward();
      }
    });

    _animationController.addListener(() {
      if (mounted && _scrollController.hasClients) {
        _scrollController.jumpTo(_animationController.value * distance);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Text(
            widget.text,
            style: widget.style,
          ),
        );
      }
    );
  }
}
