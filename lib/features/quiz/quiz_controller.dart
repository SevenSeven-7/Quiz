import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../progress/progress_provider.dart';

class QuizState {
  final LevelModel level;
  final int currentIndex;
  final int score;
  final bool isAnswered;
  final int? selectedIndex;
  final String? essayAnswer;
  final bool isFinished;
  final int timeSpent; // dalam detik

  QuizState({
    required this.level,
    this.currentIndex = 0,
    this.score = 0,
    this.isAnswered = false,
    this.selectedIndex,
    this.essayAnswer,
    this.isFinished = false,
    this.timeSpent = 0,
  });

  QuizState copyWith({
    LevelModel? level,
    int? currentIndex,
    int? score,
    bool? isAnswered,
    int? selectedIndex,
    String? essayAnswer,
    bool? isFinished,
    int? timeSpent,
  }) {
    return QuizState(
      level: level ?? this.level,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      isAnswered: isAnswered ?? this.isAnswered,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      essayAnswer: essayAnswer ?? this.essayAnswer,
      isFinished: isFinished ?? this.isFinished,
      timeSpent: timeSpent ?? this.timeSpent,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  final Ref ref;
  Timer? _timer;

  QuizNotifier(this.ref, LevelModel level)
      : super(QuizState(level: level)) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isFinished) {
        state = state.copyWith(timeSpent: state.timeSpent + 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  void answerMCQ(int index) {
    if (state.isAnswered) return;

    final question = state.level.questions[state.currentIndex];
    final isCorrect = question.correctAnswerIndex == index;

    state = state.copyWith(
      isAnswered: true,
      selectedIndex: index,
      score: isCorrect ? state.score + 1 : state.score,
    );

    Future.delayed(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  void answerEssay(String answer) {
    if (state.isAnswered) return;

    final question = state.level.questions[state.currentIndex];
    // Case insensitive validation
    final isCorrect = question.correctAnswer?.toLowerCase().trim() == answer.toLowerCase().trim();

    state = state.copyWith(
      isAnswered: true,
      essayAnswer: answer,
      score: isCorrect ? state.score + 1 : state.score,
    );

    Future.delayed(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (state.currentIndex < state.level.questions.length - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        isAnswered: false,
        selectedIndex: null,
        essayAnswer: null,
      );
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    _timer?.cancel();
    
    // Kalkulasi Bintang
    // Misal: < 30s = 3 bintang, < 60s = 2 bintang, sisanya 1 bintang
    int stars = 1;
    if (state.timeSpent < 30) {
      stars = 3;
    } else if (state.timeSpent < 60) {
      stars = 2;
    }

    // Update Progres
    ref.read(progressProvider.notifier).updateProgress(
      state.level.id,
      stars,
      state.level.partId,
    );

    state = state.copyWith(isFinished: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final quizProvider = StateNotifierProvider.family<QuizNotifier, QuizState, LevelModel>((ref, level) {
  return QuizNotifier(ref, level);
});
