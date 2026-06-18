import 'dart:math' as math;
import 'package:quiz/inti/utils/audio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../inti/layanan/layanan_api.dart';
import '../../inti/layanan/layanan_data.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';
import '../kuis/layar_kuis.dart';
import '../../inti/utils/ornament_helper.dart';

class LevelSelectionScreen extends ConsumerStatefulWidget {
  final PartModel part;
  final String? categoryName;
  final List<Color>? gradientColors;
  const LevelSelectionScreen({super.key, required this.part, this.categoryName, this.gradientColors});

  @override
  ConsumerState<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends ConsumerState<LevelSelectionScreen> {
  late ScrollController _scrollController;
  int? _lastScrolledIndex;
  late int _randomSeed;
  late List<Alignment> _shuffledAligns;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _randomSeed = math.Random().nextInt(100000);
    
    final aligns = [
      const Alignment(-0.8, -0.8), const Alignment(0.8, -0.7),
      const Alignment(-0.7, -0.4), const Alignment(0.7, -0.2),
      const Alignment(-0.8, 0.1),  const Alignment(0.8, 0.4),
      const Alignment(-0.6, 0.7),  const Alignment(0.6, 0.8),
      const Alignment(-0.5, -0.8),  const Alignment(-0.3, 0.9),
      const Alignment(0.4, -0.5),  const Alignment(-0.2, 0.5),
    ];
    aligns.shuffle(math.Random(_randomSeed));
    _shuffledAligns = aligns;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final catName = widget.categoryName ?? widget.part.cleanTitle;
    final ornaments = OrnamentHelper.getOrnamentsForCategory(catName);
    final mainChar = OrnamentHelper.getMainCharacterForCategory(catName);

    final bgColors = widget.gradientColors != null 
        ? [widget.gradientColors![0].withValues(alpha: 0.15), widget.gradientColors![1].withValues(alpha: 0.05)]
        : AppColors.backgroundGradient.colors;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar Custom
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 20, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () { AudioHelper.playClick(); Navigator.of(context).pop(); }, icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                        child: Text(
                          catName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              // Level Path (Grid S-Curve)
              Expanded(
                child: FutureBuilder<List<LevelModel>>(
                  future: DataService().getLevels(widget.part.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Memuat level...',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      );
                    }

                    final levels = snapshot.data!;
                    int highestUnlockedIndex = 0;
                    
                    for (int i = 0; i < levels.length; i++) {
                      if (i == 0) {
                        highestUnlockedIndex = 0;
                      } else {
                        final prevStars = progress.levelStars[levels[i - 1].id] ?? 0;
                        if (prevStars > 0) highestUnlockedIndex = i;
                        else break;
                      }
                    }

                    if (_lastScrolledIndex != highestUnlockedIndex && highestUnlockedIndex > 0) {
                      _lastScrolledIndex = highestUnlockedIndex;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (_scrollController.hasClients && context.mounted) {
                              final screenWidth = MediaQuery.of(context).size.width;
                              final itemWidth = (screenWidth - 96) / 3;
                              final itemHeight = itemWidth / 0.8;
                              final rowHeight = itemHeight + 32;
                              final row = highestUnlockedIndex ~/ 3;
                              final offset = 60.0 + (row * rowHeight) - (MediaQuery.of(context).size.height / 2) + (itemHeight / 2);
                              
                              _scrollController.animateTo(
                                offset.clamp(0.0, _scrollController.position.maxScrollExtent),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOutCubic,
                              );
                            }
                          });
                        }
                      });
                    }

                    return Stack(
                      children: [
                        // Giant Watermark di tengah
                        Center(
                          child: Opacity(
                            opacity: 0.15,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                mainChar,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 300, height: 1.0),
                              ),
                            ),
                          ),
                        ),

                        // Ornamen Dinamis
                        ...(() {
                          final rand = math.Random(_randomSeed);

                          return List.generate(ornaments.length, (i) {
                            final align = _shuffledAligns[i % _shuffledAligns.length];
                            final size = 35.0 + rand.nextInt(20); 
                            final duration = 3 + rand.nextInt(3); 
                            final animType = rand.nextInt(3); 
                            
                            var anim = Text(ornaments[i], style: TextStyle(fontSize: size))
                                .animate(onPlay: (c) => c.repeat(reverse: true));
                            
                            if (animType == 0) {
                              anim = anim.slideX(duration: duration.seconds, curve: Curves.easeInOutSine, begin: -0.05, end: 0.05);
                            } else if (animType == 1) {
                              anim = anim.slideY(duration: duration.seconds, curve: Curves.easeInOutSine, begin: -0.05, end: 0.05);
                            } else {
                              anim = anim.scale(duration: duration.seconds, curve: Curves.easeInOut, begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1));
                            }

                            return Align(alignment: align, child: anim);
                          });
                        })(),

                        // Grid Level dengan S-Curve Path
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GridView.builder(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: 60, bottom: 120),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 32,
                              crossAxisSpacing: 24,
                              childAspectRatio: 0.8, // Ruang untuk tombol dan teks
                            ),
                            itemCount: (levels.length / 3).ceil() * 3, // Genapkan ke kelipatan 3
                            itemBuilder: (context, gridIndex) {
                              // Konversi gridIndex menjadi levelIndex zigzag (S-Curve)
                              // Baris genap: kiri ke kanan. Baris ganjil: kanan ke kiri.
                              final r = gridIndex ~/ 3;
                              final c = gridIndex % 3;
                              final levelIndex = (r % 2 == 0) ? gridIndex : (r * 3 + (2 - c));

                              // Jika levelIndex melewati jumlah level yang ada, kosongkan
                              if (levelIndex >= levels.length) return const SizedBox();

                              final levelData = levels[levelIndex];
                              final levelNumber = levelData.order;
                              final levelId = levelData.id;
                              final stars = progress.levelStars[levelId] ?? 0;

                              bool isUnlocked = levelIndex == 0 || (progress.levelStars[levels[levelIndex - 1].id] ?? 0) > 0;
                              bool isNextUnlocked = levelIndex < levels.length - 1 && (progress.levelStars[levelId] ?? 0) > 0;

                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  final w = constraints.maxWidth;
                                  final h = constraints.maxHeight;
                                  const spacingX = 24.0;
                                  const spacingY = 32.0;
                                  const stroke = 8.0;

                                  Widget? lineRight;
                                  Widget? lineDown;
                                  
                                  final buttonSize = w * 0.9;
                                  final lineCenterY = buttonSize / 2;
                                  final currentLevelIdx = levelIndex;

                                  // Gambar garis ke KANAN
                                  if (c < 2) {
                                    final int rightGridIndex = gridIndex + 1;
                                    final int rightLevelIdx = (r % 2 == 0) ? rightGridIndex : (r * 3 + (2 - (c + 1)));
                                    if (rightLevelIdx < levels.length) {
                                       final maxLevelIdx = math.max(currentLevelIdx, rightLevelIdx);
                                       bool isMaxUnlocked = maxLevelIdx == 0 || (progress.levelStars[levels[maxLevelIdx - 1].id] ?? 0) > 0;
                                       
                                       final color = isMaxUnlocked 
                                          ? (widget.gradientColors?[0] ?? AppColors.primary).withValues(alpha: 0.5) 
                                          : Colors.black12;

                                       lineRight = Positioned(
                                          left: w / 2, top: lineCenterY - stroke / 2,
                                          child: Container(width: w + spacingX, height: stroke, color: color),
                                       );
                                    }
                                  }
                                  
                                  // Gambar garis ke BAWAH
                                  if ((r % 2 == 0 && c == 2) || (r % 2 == 1 && c == 0)) {
                                    final int downGridIndex = gridIndex + 3;
                                    final int downLevelIdx = ((r+1) % 2 == 0) ? downGridIndex : ((r+1) * 3 + (2 - c));
                                    if (downLevelIdx < levels.length) {
                                       final maxLevelIdx = math.max(currentLevelIdx, downLevelIdx);
                                       bool isMaxUnlocked = maxLevelIdx == 0 || (progress.levelStars[levels[maxLevelIdx - 1].id] ?? 0) > 0;
                                       
                                       final color = isMaxUnlocked 
                                          ? (widget.gradientColors?[0] ?? AppColors.primary).withValues(alpha: 0.5) 
                                          : Colors.black12;

                                       lineDown = Positioned(
                                          left: w / 2 - stroke / 2, top: lineCenterY,
                                          child: Container(width: stroke, height: h + spacingY, color: color),
                                       );
                                    }
                                  }

                                  return Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.topCenter,
                                    children: [
                                      // Garis Jalur (dirender duluan agar berada di bawah tombol bulat)
                                      if (lineRight != null) lineRight,
                                      if (lineDown != null) lineDown,
                                      
                                      // Tombol Level Bulat
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildLevelButton(
                                            context, levelNumber, isUnlocked, stars, levelData, levelIndex, w
                                          ),
                                          const SizedBox(height: 8),
                                          // Teks Level di Bawah Bulatan
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isUnlocked ? AppColors.surface.withValues(alpha: 0.8) : Colors.transparent,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                'Lvl $levelNumber',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: isUnlocked ? AppColors.textPrimary : Colors.black38,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(
    BuildContext context, int number, bool isUnlocked, int stars, LevelModel levelData, int index, double maxWidth
  ) {
    final isComplete = stars == 3;
    final isCurrent = isUnlocked && stars == 0;
    
    Color? borderColor;
    Gradient? gradient;
    Color iconColor = Colors.black26;

    if (isComplete) {
      borderColor = AppColors.gold.withValues(alpha: 0.8);
      gradient = AppColors.goldGradient;
    } else if (isUnlocked) {
      borderColor = widget.gradientColors != null ? widget.gradientColors![0].withValues(alpha: 0.5) : AppColors.primary.withValues(alpha: 0.4);
      gradient = widget.gradientColors != null 
          ? LinearGradient(colors: widget.gradientColors!, begin: Alignment.topLeft, end: Alignment.bottomRight)
          : AppColors.primaryGradient;
    } else {
      borderColor = Colors.black12;
    }

    final buttonSize = maxWidth * 0.9; // Buat bulatan responsif tapi maksimal sebesar kolom

    Widget buttonNode = InkWell(
      onTap: isUnlocked
          ? () async {
              AudioHelper.playClick();
              final fetchedQuestions = await ApiService().getQuestionsForLevel(levelData.partId, levelData.order);
              
              if (fetchedQuestions.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal memuat soal.'), backgroundColor: Colors.red),
                  );
                }
                return;
              }

              final newLevel = LevelModel(
                id: levelData.id,
                order: levelData.order,
                partId: levelData.partId,
                questions: fetchedQuestions,
                stars: levelData.stars,
                isUnlocked: levelData.isUnlocked,
              );

              if (context.mounted) {
                await Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => QuizScreen(
                      level: newLevel, 
                      categoryName: widget.categoryName,
                      gradientColors: widget.gradientColors,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                );
                
                if (context.mounted) {
                  setState(() {
                    _lastScrolledIndex = null;
                  });
                }
              }
            }
          : null,
      borderRadius: BorderRadius.circular(100), // Bundar penuh
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Lingkaran Tombol
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null
                  ? (isUnlocked ? AppColors.surface : AppColors.surfaceLight.withValues(alpha: 0.5))
                  : null,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: isUnlocked ? 3 : 1.5,
              ),
              boxShadow: isComplete
                  ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 1, offset: const Offset(0, 3))]
                  : isCurrent
                      ? [BoxShadow(color: widget.gradientColors != null ? widget.gradientColors![0].withValues(alpha: 0.4) : AppColors.primary.withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 2, offset: const Offset(0, 4))]
                      : isUnlocked
                          ? [BoxShadow(color: widget.gradientColors != null ? widget.gradientColors![0].withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2))]
                          : null,
            ),
            child: Center(
              child: isUnlocked
                  ? Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: gradient != null ? Colors.white : AppColors.textPrimary,
                      ),
                    )
                  : Icon(Icons.lock_rounded, color: iconColor, size: 24),
            ),
          ),
          
          // Bayangan bintang melengkung di bawah tombol
          if (isUnlocked && stars > 0)
            Positioned(
              bottom: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppColors.cardShadow,
                  border: Border.all(color: Colors.black12, width: 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    return Icon(
                      i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 10,
                      color: i < stars ? AppColors.gold : Colors.black12,
                    );
                  }),
                ),
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.5, end: 0),
        ],
      ),
    );

    return isCurrent
        ? buttonNode.animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1.seconds)
        : buttonNode.animate().scale(delay: ((index % 10) * 30).ms, duration: 400.ms, curve: Curves.easeOutBack);
  }
}

