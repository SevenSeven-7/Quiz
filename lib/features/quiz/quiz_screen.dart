import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../models/models.dart';
import 'quiz_controller.dart';
import '../result/result_screen.dart';

class QuizScreen extends ConsumerWidget {
  final CategoryModel category;
  const QuizScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizProvider(category.id));

    // Listen for finish state
    ref.listen(quizProvider(category.id), (previous, next) {
      if (next.isFinished) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: next.score),
          ),
        );
      }
    });

    if (state.questions.isEmpty) {
      return const Scaffold(body: Center(child: Text('Tidak ada soal.')));
    }

    final currentQuestion = state.questions[state.currentIndex];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildTopBar(context, state),
              const Spacer(),
              _buildQuestionArea(context, currentQuestion),
              const Spacer(),
              _buildAnswerOptions(context, state, ref, currentQuestion),
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
              '${state.currentIndex + 1} / ${state.questions.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 48), // Spacer
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: (state.currentIndex + 1) / state.questions.length,
          backgroundColor: AppColors.surface,
          color: AppColors.primary,
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  Widget _buildQuestionArea(BuildContext context, QuestionModel question) {
    return Center(
      child: Text(
        question.text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 26,
              height: 1.4,
            ),
      ).animate().fadeIn().scale(),
    );
  }

  Widget _buildAnswerOptions(BuildContext context, QuizState state, WidgetRef ref, QuestionModel question) {
    return Column(
      children: List.generate(question.options.length, (index) {
        final option = question.options[index];
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
          padding: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () => ref.read(quizProvider(category.id).notifier).answerQuestion(index),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Text(
                option,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ).animate(target: isSelected && state.isAnswered && !isCorrect ? 1 : 0)
           .shake(hz: 10, curve: Curves.easeInOut),
        );
      }),
    );
  }
}
