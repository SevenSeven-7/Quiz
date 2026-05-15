import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../core/data/mock_data.dart';

class QuizState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final int score;
  final bool isAnswered;
  final int? selectedIndex;
  final bool isFinished;

  QuizState({
    required this.questions,
    this.currentIndex = 0,
    this.score = 0,
    this.isAnswered = false,
    this.selectedIndex,
    this.isFinished = false,
  });

  QuizState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    int? score,
    bool? isAnswered,
    int? selectedIndex,
    bool? isFinished,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      isAnswered: isAnswered ?? this.isAnswered,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier(String categoryId)
      : super(QuizState(
          questions: MockData.questions
              .where((q) => q.categoryId == categoryId)
              .toList()
            ..shuffle(),
        ));

  void answerQuestion(int index) {
    if (state.isAnswered) return;

    final isCorrect = state.questions[state.currentIndex].correctAnswerIndex == index;
    state = state.copyWith(
      isAnswered: true,
      selectedIndex: index,
      score: isCorrect ? state.score + 10 : state.score,
    );

    Future.delayed(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        isAnswered: false,
        selectedIndex: null,
      );
    } else {
      state = state.copyWith(isFinished: true);
    }
  }
}

final quizProvider = StateNotifierProvider.family<QuizNotifier, QuizState, String>((ref, categoryId) {
  return QuizNotifier(categoryId);
});
