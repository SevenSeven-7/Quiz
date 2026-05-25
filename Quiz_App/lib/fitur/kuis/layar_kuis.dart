import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../model/model.dart';
import 'pengendali_kuis.dart';
import '../hasil/layar_hasil.dart';
import '../../inti/penyedia/penyedia_tema.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final LevelModel level;
  const QuizScreen({super.key, required this.level});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _essayController = TextEditingController();
  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(vsync: this, duration: const Duration(seconds: 60))
      ..forward();
  }

  @override
  void dispose() {
    _essayController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider(widget.level));
    final appTheme = ref.watch(temaProvider);
    final isDark = appTheme == AppThemeMode.dark;
    final isComputer = appTheme == AppThemeMode.computer;

    ref.listen(quizProvider(widget.level), (previous, next) {
      if (next.isFinished) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => ResultScreen(
              score: next.score,
              totalQuestions: next.level.questions.length,
              stars: next.starsEarned,
              partId: widget.level.partId,
            ),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    });

    if (state.level.questions.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.background : (isComputer ? AppColors.backgroundComputer : AppColors.backgroundLightBlue),
        body: Center(child: Text('Tidak ada soal.', style: TextStyle(color: isDark ? Colors.white : (isComputer ? AppColors.textPrimaryComputer : AppColors.textPrimaryLight)))),
      );
    }

    final currentQuestion = state.level.questions[state.currentIndex];
    final progress = (state.currentIndex + 1) / state.level.questions.length;

    final bgGradient = isComputer ? AppColors.backgroundComputerGradient : (isDark ? AppColors.backgroundGradient : AppColors.backgroundLightGradient);
    final textColor = isDark ? Colors.white : (isComputer ? AppColors.textPrimaryComputer : AppColors.textPrimaryLight);
    final surfaceColor = isDark ? AppColors.surfaceLight : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightModeSecond);
    final primaryGrad = isComputer ? AppColors.primaryComputerGradient : AppColors.primaryGradient;
    final glow = isComputer ? AppColors.computerShadow : (isDark ? AppColors.primaryGlow : AppColors.lightShadow);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
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
                          onTap: () => _showQuitDialog(context, isDark, isComputer),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isComputer ? AppColors.surfaceComputerBorder : (isDark ? Colors.white10 : Colors.black12)),
                            ),
                            child: Icon(Icons.close_rounded, color: textColor, size: 18),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Level ${widget.level.order}',
                              style: TextStyle(
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
                    const SizedBox(height: 14),
                    // Progress Bar Gradien
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: isComputer ? AppColors.surfaceComputerBorder : (isDark ? Colors.white10 : Colors.black12),
                          valueColor: AlwaysStoppedAnimation<Color>(isComputer ? AppColors.primaryComputer : AppColors.primary),
                          minHeight: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    children: [
                      // Timer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            '${state.timeSpent}s',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ).animate().fadeIn(duration: 300.ms),

                      const SizedBox(height: 24),

                      // Tipe soal badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: primaryGrad,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: glow,
                        ),
                        child: Text(
                          currentQuestion.type == QuestionType.mcq ? 'Pilihan Ganda' : 'Uraian',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ).animate().fadeIn(delay: 100.ms),

                      const SizedBox(height: 24),

                      // Kartu Soal glassmorphism
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: surfaceColor.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isComputer ? AppColors.surfaceComputerBorder : AppColors.primary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: isComputer ? AppColors.computerCardShadow : [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              blurRadius: 24,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          currentQuestion.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ).animate(key: ValueKey(state.currentIndex))
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.1, end: 0, duration: 300.ms),

                      const SizedBox(height: 28),

                      // Pilihan jawaban
                      if (currentQuestion.type == QuestionType.mcq)
                        _buildMCQOptions(context, state, ref, currentQuestion, isDark, isComputer, textColor)
                      else
                        _buildEssayInput(context, state, ref, isDark, isComputer, textColor, surfaceColor, primaryGrad, glow),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuitDialog(BuildContext context, bool isDark, bool isComputer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : (isComputer ? AppColors.surfaceComputer : AppColors.surfaceLightBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isComputer ? AppColors.surfaceComputerBorder : AppColors.primary.withValues(alpha: 0.3)),
        ),
        title: Text('Keluar dari Quiz?', style: TextStyle(color: isDark ? Colors.white : (isComputer ? AppColors.textPrimaryComputer : AppColors.textPrimaryLight))),
        content: const Text(
          'Progres soalmu saat ini akan hilang.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Lanjutkan', style: TextStyle(color: isComputer ? AppColors.primaryComputer : AppColors.primary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Keluar', style: TextStyle(color: AppColors.failure)),
          ),
        ],
      ),
    );
  }

  Widget _buildMCQOptions(BuildContext context, QuizState state, WidgetRef ref, QuestionModel question, bool isDark, bool isComputer, Color mainTextColor) {
    return Column(
      children: List.generate(question.options?.length ?? 0, (index) {
        final option = question.options![index];
        final isSelected = state.selectedIndex == index;
        final isCorrect = question.correctAnswerIndex == index;

        Color borderColor = isComputer ? AppColors.surfaceComputerBorder : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1));
        Color bgColor = isComputer ? AppColors.surfaceComputer : Colors.transparent;
        Color? glowColor;

        if (state.isAnswered) {
          if (isCorrect) {
            borderColor = AppColors.success;
            bgColor = AppColors.success.withValues(alpha: 0.12);
            glowColor = AppColors.success;
          } else if (isSelected) {
            borderColor = AppColors.failure;
            bgColor = AppColors.failure.withValues(alpha: 0.12);
            glowColor = AppColors.failure;
          }
        } else if (isSelected) {
          borderColor = isComputer ? AppColors.primaryComputer : AppColors.primary;
          bgColor = isComputer ? AppColors.primaryComputer.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.08);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () => ref.read(quizProvider(widget.level).notifier).answerMCQ(index),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: glowColor != null
                    ? [BoxShadow(color: glowColor.withValues(alpha: 0.2), blurRadius: 12)]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isSelected && !state.isAnswered
                          ? (isComputer ? AppColors.primaryComputer : AppColors.primary)
                          : (isComputer ? Colors.black12 : (isDark ? Colors.white10 : Colors.black12)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          color: isSelected && !state.isAnswered ? Colors.white : (isComputer ? Colors.black54 : (isDark ? Colors.white54 : Colors.black54)),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: state.isAnswered && isCorrect
                            ? AppColors.success
                            : state.isAnswered && isSelected
                                ? AppColors.failure
                                : mainTextColor,
                      ),
                    ),
                  ),
                  if (state.isAnswered)
                    isCorrect
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20)
                        : (isSelected
                            ? const Icon(Icons.cancel_rounded, color: AppColors.failure, size: 20)
                            : const SizedBox.shrink()),
                ],
              ),
            ),
          ).animate(target: isSelected && state.isAnswered && !isCorrect ? 1 : 0)
              .shake(hz: 6, curve: Curves.easeInOut),
        );
      }),
    );
  }

  Widget _buildEssayInput(BuildContext context, QuizState state, WidgetRef ref, bool isDark, bool isComputer, Color textColor, Color surfaceColor, Gradient primaryGrad, List<BoxShadow> glow) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: state.isAnswered ? (isComputer ? AppColors.primaryComputer : AppColors.primary).withValues(alpha: 0.5) : (isComputer ? AppColors.surfaceComputerBorder : (isDark ? Colors.white10 : Colors.black12)),
            ),
          ),
          child: TextField(
            controller: _essayController,
            enabled: !state.isAnswered,
            style: TextStyle(color: textColor, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Ketik jawaban Anda di sini...',
              hintStyle: TextStyle(color: isComputer ? Colors.black38 : (isDark ? Colors.white30 : Colors.black38)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!state.isAnswered)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: isComputer ? AppColors.primaryComputerGradient : AppColors.buttonGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: glow,
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_essayController.text.isNotEmpty) {
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
