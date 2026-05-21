import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inti/konstanta/warna_aplikasi.dart';
import '../../model/model.dart';
import 'pengendali_kuis.dart';
import '../hasil/layar_hasil.dart';

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
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Tidak ada soal.', style: TextStyle(color: Colors.white))),
      );
    }

    final currentQuestion = state.level.questions[state.currentIndex];
    final progress = (state.currentIndex + 1) / state.level.questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
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
                          onTap: () => _showQuitDialog(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Level ${widget.level.order}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white,
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
                          backgroundColor: Colors.white10,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
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
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppColors.primaryGlow,
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
                          color: AppColors.surfaceLight.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
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
                          style: const TextStyle(
                            fontSize: 20,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ).animate(key: ValueKey(state.currentIndex))
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.1, end: 0, duration: 300.ms),

                      const SizedBox(height: 28),

                      // Pilihan jawaban
                      if (currentQuestion.type == QuestionType.mcq)
                        _buildMCQOptions(context, state, ref, currentQuestion)
                      else
                        _buildEssayInput(context, state, ref),
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

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        title: const Text('Keluar dari Quiz?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Progres soalmu saat ini akan hilang.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Lanjutkan', style: TextStyle(color: AppColors.primary)),
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

  Widget _buildMCQOptions(BuildContext context, QuizState state, WidgetRef ref, QuestionModel question) {
    return Column(
      children: List.generate(question.options?.length ?? 0, (index) {
        final option = question.options![index];
        final isSelected = state.selectedIndex == index;
        final isCorrect = question.correctAnswerIndex == index;

        Color borderColor = Colors.white.withValues(alpha: 0.1);
        Color bgColor = Colors.transparent;
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
          borderColor = AppColors.primary;
          bgColor = AppColors.primary.withValues(alpha: 0.08);
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
                          ? AppColors.primary
                          : Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          color: isSelected && !state.isAnswered ? Colors.white : Colors.white54,
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
                                : Colors.white,
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

  Widget _buildEssayInput(BuildContext context, QuizState state, WidgetRef ref) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: state.isAnswered ? AppColors.primary.withValues(alpha: 0.5) : Colors.white10,
            ),
          ),
          child: TextField(
            controller: _essayController,
            enabled: !state.isAnswered,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: const InputDecoration(
              hintText: 'Ketik jawaban Anda di sini...',
              hintStyle: TextStyle(color: Colors.white30),
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
              boxShadow: AppColors.primaryGlow,
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
