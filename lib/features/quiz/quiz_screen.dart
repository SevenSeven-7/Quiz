import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../models/models.dart';
import 'quiz_controller.dart';
import '../result/result_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final LevelModel level;
  const QuizScreen({super.key, required this.level});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final TextEditingController _essayController = TextEditingController();

  @override
  void dispose() {
    _essayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider(widget.level));

    // Listen for finish state
    ref.listen(quizProvider(widget.level), (previous, next) {
      if (next.isFinished) {
        // Hitung bintang (logika ada di controller)
        // Untuk sekarang kita oper saja datanya
        int stars = 1;
        if (next.timeSpent < 30) stars = 3;
        else if (next.timeSpent < 60) stars = 2;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              score: next.score,
              totalQuestions: next.level.questions.length,
              stars: stars,
              partId: widget.level.partId,
            ),
          ),
        );
      }
    });

    if (state.level.questions.isEmpty) {
      return const Scaffold(body: Center(child: Text('Tidak ada soal.')));
    }

    final currentQuestion = state.level.questions[state.currentIndex];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildTopBar(context, state),
              const SizedBox(height: 20),
              _buildTimer(context, state),
              const Spacer(),
              _buildQuestionArea(context, currentQuestion, state.currentIndex + 1),
              const Spacer(),
              if (currentQuestion.type == QuestionType.mcq)
                _buildMCQOptions(context, state, ref, currentQuestion)
              else
                _buildEssayInput(context, state, ref),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, QuizState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text(
              'Level ${widget.level.order}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              '${state.currentIndex + 1} / ${state.level.questions.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: (state.currentIndex + 1) / state.level.questions.length,
          backgroundColor: AppColors.surface,
          color: AppColors.primary,
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  Widget _buildTimer(BuildContext context, QuizState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          'Waktu: ${state.timeSpent}s',
          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildQuestionArea(BuildContext context, QuestionModel question, int index) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            question.type == QuestionType.mcq ? 'Pilihan Ganda' : 'Uraian',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          question.text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 24,
                height: 1.4,
              ),
        ).animate(key: ValueKey(index)).fadeIn().scale(),
      ],
    );
  }

  Widget _buildMCQOptions(BuildContext context, QuizState state, WidgetRef ref, QuestionModel question) {
    return Column(
      children: List.generate(question.options?.length ?? 0, (index) {
        final option = question.options![index];
        final isSelected = state.selectedIndex == index;
        final isCorrect = question.correctAnswerIndex == index;
        
        Color borderColor = Colors.white.withOpacity(0.1);
        Color bgColor = Colors.transparent;

        if (state.isAnswered) {
          if (isCorrect) {
            borderColor = AppColors.success;
            bgColor = AppColors.success.withOpacity(0.1);
          } else if (isSelected) {
            borderColor = AppColors.failure;
            bgColor = AppColors.failure.withOpacity(0.1);
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () => ref.read(quizProvider(widget.level).notifier).answerMCQ(index),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Row(
                children: [
                  Text(
                    String.fromCharCode(65 + index) + '.',
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ).animate(target: isSelected && state.isAnswered && !isCorrect ? 1 : 0)
           .shake(hz: 10, curve: Curves.easeInOut),
        );
      }),
    );
  }

  Widget _buildEssayInput(BuildContext context, QuizState state, WidgetRef ref) {
    return Column(
      children: [
        TextField(
          controller: _essayController,
          enabled: !state.isAnswered,
          decoration: InputDecoration(
            hintText: 'Ketik jawaban Anda di sini...',
            fillColor: AppColors.surface,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              ref.read(quizProvider(widget.level).notifier).answerEssay(value);
              _essayController.clear();
            }
          },
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isAnswered ? null : () {
              if (_essayController.text.isNotEmpty) {
                ref.read(quizProvider(widget.level).notifier).answerEssay(_essayController.text);
                _essayController.clear();
              }
            },
            child: const Text('Kirim Jawaban'),
          ),
        ),
        if (state.isAnswered) ...[
           const SizedBox(height: 16),
           Text(
             state.essayAnswer?.toLowerCase().trim() == state.level.questions[state.currentIndex].correctAnswer?.toLowerCase().trim()
              ? 'Jawaban Benar!' : 'Jawaban Salah! Yang benar: ${state.level.questions[state.currentIndex].correctAnswer}',
             style: TextStyle(
               color: state.essayAnswer?.toLowerCase().trim() == state.level.questions[state.currentIndex].correctAnswer?.toLowerCase().trim()
                ? AppColors.success : AppColors.failure,
               fontWeight: FontWeight.bold,
             ),
           ).animate().fadeIn(),
        ]
      ],
    );
  }
}
