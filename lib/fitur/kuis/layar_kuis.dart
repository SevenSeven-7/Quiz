import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../model/model.dart';
import 'pengendali_kuis.dart';
import '../hasil/layar_hasil.dart';
import '../../inti/utils/audio_helper.dart';
import '../../inti/utils/transisi_halaman.dart';
import '../../inti/utils/ornament_helper.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final LevelModel level;
  final String? categoryName;
  final List<Color>? gradientColors;

  const QuizScreen({
    super.key, 
    required this.level, 
    this.categoryName,
    this.gradientColors,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _essayController = TextEditingController();
  late AnimationController _timerController;
  final AudioPlayer _player = AudioPlayer();
  bool _isSoundEnabled = true;
  double _ukuranTeks = 22.0;
  late int _randomSeed;
  late List<Alignment> _shuffledAligns;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(vsync: this, duration: const Duration(seconds: 60))
      ..forward();
    _initSoundSetting();
    
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

  Future<void> _initSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isSoundEnabled = prefs.getBool('pengaturan_suara') ?? true;
      });
    }
  }

  Future<void> _playSound(bool isCorrect) async {
    if (!_isSoundEnabled) return;
    try {
      if (isCorrect) {
        await _player.play(AssetSource('sounds/suara-benar.mp3'));
      } else {
        await _player.play(AssetSource('sounds/suara-salah.mp3'));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Audio Play Error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _essayController.dispose();
    _timerController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider(widget.level));

    ref.listen(quizProvider(widget.level), (previous, next) {
      if (next.isFinished) {
        Navigator.of(context).pushReplacement(
          TransisiPremium(
            child: ResultScreen(
              score: next.score,
              totalQuestions: next.level.questions.length,
              stars: next.starsEarned,
              partId: widget.level.partId,
            ),
          ),
        );
      }
    });

    if (state.level.questions.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Tidak ada soal.', style: TextStyle(color: AppColors.textPrimary))),
      );
    }

    final currentQuestion = state.level.questions[state.currentIndex];
    final progress = (state.currentIndex + 1) / state.level.questions.length;

    final hasGradient = widget.gradientColors != null;
    final List<Color> bgColors = hasGradient 
        ? <Color>[widget.gradientColors![0].withValues(alpha: 0.15), widget.gradientColors![1].withValues(alpha: 0.05)]
        : AppColors.backgroundGradient.colors;
        
    final mainColor = hasGradient ? widget.gradientColors![0] : AppColors.primary;
    final accentColor = hasGradient ? widget.gradientColors![1] : AppColors.accent;
        
    const textColor = AppColors.textPrimary;
    final surfaceColor = AppColors.surface;
    final primaryGrad = hasGradient 
        ? LinearGradient(colors: widget.gradientColors!, begin: Alignment.topLeft, end: Alignment.bottomRight) 
        : AppColors.primaryGradient;
    final glow = [BoxShadow(color: mainColor.withValues(alpha: 0.3), blurRadius: 16, spreadRadius: 2, offset: const Offset(0, 8))];

    final catName = widget.categoryName ?? widget.level.partId;
    final ornaments = OrnamentHelper.getOrnamentsForCategory(catName);
    final mainChar = OrnamentHelper.getMainCharacterForCategory(catName);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        child: Stack(
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

            // Area Utama
            SafeArea(
              child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            AudioHelper.playClick();
                            _showQuitDialog(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: const Icon(Icons.close_rounded, color: textColor, size: 18),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Level ${widget.level.order}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            '${state.currentIndex + 1}/${state.level.questions.length}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar Gradien (Premium)
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutBack,
                            width: MediaQuery.of(context).size.width * progress,
                            decoration: BoxDecoration(
                              gradient: primaryGrad,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: mainColor.withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0, 2))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.5, end: 0, curve: Curves.easeOutBack),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    children: [
                      // Timer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  '${state.timeSpent}s',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 300.ms),

                      const SizedBox(height: 24),

                      // Kontrol Ukuran Teks
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              AudioHelper.playClick();
                              if (_ukuranTeks > 14) setState(() => _ukuranTeks -= 2);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.remove_rounded, size: 20, color: AppColors.primary),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.text_format_rounded, size: 22, color: Colors.black26),
                          ),
                          InkWell(
                            onTap: () {
                              AudioHelper.playClick();
                              if (_ukuranTeks < 36) setState(() => _ukuranTeks += 2);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add_rounded, size: 20, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: 24),

                      // Kartu Soal Premium
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: mainColor.withValues(alpha: 0.15),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: mainColor.withValues(alpha: 0.06),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Text(
                                currentQuestion.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: _ukuranTeks,
                                  height: 1.5,
                                  fontWeight: FontWeight.w800,
                                  color: textColor.withValues(alpha: 0.9),
                                ),
                              ),
                            ).animate(key: ValueKey(state.currentIndex))
                                .fadeIn(duration: 400.ms)
                                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), curve: Curves.easeOutCubic),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Pilihan jawaban
                      if (currentQuestion.type == QuestionType.mcq)
                        _buildMCQOptions(context, state, ref, currentQuestion, textColor)
                      else
                        _buildEssayInput(context, state, ref, textColor, surfaceColor, primaryGrad, glow),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        title: const Text('Keluar dari Quiz?', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Progres soalmu saat ini akan hilang.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AudioHelper.playClick();
              Navigator.pop(context);
            },
            child: const Text('Lanjutkan', style: TextStyle(color: AppColors.primary)),
          ),
          TextButton(
            onPressed: () {
              AudioHelper.playClick();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Keluar', style: TextStyle(color: AppColors.failure)),
          ),
        ],
      ),
    );
  }

  Widget _buildMCQOptions(BuildContext context, QuizState state, WidgetRef ref, QuestionModel question, Color mainTextColor) {
    return Column(
      children: List.generate(question.options?.length ?? 0, (index) {
        final option = question.options![index];
        final isSelected = state.selectedIndex == index;
        final isCorrect = question.correctAnswerIndex == index;

        Color borderColor = Colors.black.withValues(alpha: 0.05);
        Color bgColor = AppColors.surface;
        Color? glowColor;
        Color textColor = AppColors.textPrimary;

        if (state.isAnswered) {
          if (isCorrect) {
            borderColor = AppColors.success;
            bgColor = AppColors.success.withValues(alpha: 0.1);
            glowColor = AppColors.success;
            textColor = AppColors.success;
          } else if (isSelected) {
            borderColor = AppColors.failure;
            bgColor = AppColors.failure.withValues(alpha: 0.1);
            glowColor = AppColors.failure;
            textColor = AppColors.failure;
          }
        } else if (isSelected) {
          borderColor = AppColors.primary;
          bgColor = AppColors.primary.withValues(alpha: 0.05);
          textColor = AppColors.primary;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              if (!state.isAnswered) {
                _playSound(isCorrect);
                ref.read(quizProvider(widget.level).notifier).answerMCQ(index);
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: borderColor,
                  width: isSelected || (state.isAnswered && isCorrect) ? 2.5 : 1.5,
                ),
                boxShadow: glowColor != null
                    ? [BoxShadow(color: glowColor.withValues(alpha: 0.2), blurRadius: 15, spreadRadius: 1)]
                    : isSelected 
                        ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 10)]
                        : [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 5, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: (_ukuranTeks - 5).clamp(12.0, 30.0), // Scale relative to question size
                        fontWeight: isSelected || (state.isAnswered && isCorrect) ? FontWeight.bold : FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (state.isAnswered && isCorrect)
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24)
                        .animate().scale(duration: 400.ms, curve: Curves.elasticOut)
                  else if (state.isAnswered && isSelected && !isCorrect)
                    const Icon(Icons.cancel_rounded, color: AppColors.failure, size: 24)
                        .animate().scale(duration: 400.ms, curve: Curves.elasticOut)
                  else if (isSelected)
                     const Icon(Icons.radio_button_checked_rounded, color: AppColors.primary, size: 24)
                        .animate().scale(duration: 300.ms)
                  else
                     const Icon(Icons.radio_button_off_rounded, color: Colors.black12, size: 24),
                ],
              ),
            ),
          ),
        ).animate(key: ValueKey('${state.currentIndex}_$index'))
            .fadeIn(delay: (300 + index * 100).ms, duration: 400.ms)
            .slideX(begin: 0.1, end: 0, delay: (300 + index * 100).ms, duration: 400.ms, curve: Curves.easeOutCubic)
            .animate(target: isSelected && state.isAnswered && !isCorrect ? 1 : 0)
            .shake(hz: 6, curve: Curves.easeInOut);
      }),
    );
  }

  Widget _buildEssayInput(BuildContext context, QuizState state, WidgetRef ref, Color textColor, Color surfaceColor, Gradient primaryGrad, List<BoxShadow> glow) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: state.isAnswered ? AppColors.primary.withValues(alpha: 0.5) : Colors.black12,
            ),
          ),
          child: TextField(
            controller: _essayController,
            enabled: !state.isAnswered,
            style: TextStyle(color: textColor, fontSize: 16),
            decoration: const InputDecoration(
              hintText: 'Ketik jawaban Anda di sini...',
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(20),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!state.isAnswered)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: glow,
            ),
            child: ElevatedButton(
              onPressed: () {
                if (!state.isAnswered && _essayController.text.isNotEmpty) {
                  final isCorrect = state.level.questions[state.currentIndex].correctAnswer?.toLowerCase().trim() == _essayController.text.toLowerCase().trim();
                  _playSound(isCorrect);
                  ref.read(quizProvider(widget.level).notifier).answerEssay(_essayController.text);
                  _essayController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Kirim Jawaban',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        if (state.isAnswered) ...[
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (state.essayAnswer?.toLowerCase().trim() ==
                      state.level.questions[state.currentIndex].correctAnswer?.toLowerCase().trim()
                  ? AppColors.success
                  : AppColors.failure)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: (state.essayAnswer?.toLowerCase().trim() ==
                        state.level.questions[state.currentIndex].correctAnswer?.toLowerCase().trim()
                    ? AppColors.success
                    : AppColors.failure)
                    .withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              state.essayAnswer?.toLowerCase().trim() ==
                      state.level.questions[state.currentIndex].correctAnswer?.toLowerCase().trim()
                  ? '✓ Jawaban Benar!'
                  : '✗ Yang benar: ${state.level.questions[state.currentIndex].correctAnswer}',
              style: TextStyle(
                color: state.essayAnswer?.toLowerCase().trim() ==
                        state.level.questions[state.currentIndex].correctAnswer?.toLowerCase().trim()
                    ? AppColors.success
                    : AppColors.failure,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
        ],
      ],
    );
  }
}
