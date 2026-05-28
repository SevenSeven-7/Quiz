import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/model.dart';
import '../progres/penyedia_progres.dart';

// Kelas QuizState menampung status dinamis selama kuis sedang berjalan.
class QuizState {
  final LevelModel level; // Level kuis yang sedang dimainkan
  final int currentIndex; // Indeks nomor soal saat ini (dimulai dari 0)
  final int score; // Skor jumlah jawaban benar
  final bool isAnswered; // Status apakah soal saat ini sudah dijawab oleh pemain
  final int? selectedIndex; // Indeks pilihan ganda yang dipilih oleh pemain (jika MCQ)
  final String? essayAnswer; // Teks jawaban yang diketik oleh pemain (jika Essay)
  final bool isFinished; // Status apakah kuis telah selesai
  final int timeSpent; // Total waktu pengerjaan kuis dalam satuan detik
  final int starsEarned; // Jumlah perolehan bintang hasil akhir kuis (0-3)

  QuizState({
    required this.level,
    this.currentIndex = 0,
    this.score = 0,
    this.isAnswered = false,
    this.selectedIndex,
    this.essayAnswer,
    this.isFinished = false,
    this.timeSpent = 0,
    this.starsEarned = 0,
  });

  // Salin status kuis dengan beberapa perubahan (copyWith pattern)
  QuizState copyWith({
    LevelModel? level,
    int? currentIndex,
    int? score,
    bool? isAnswered,
    int? selectedIndex,
    bool resetSelectedIndex = false,  // Flag untuk reset
    String? essayAnswer,
    bool resetEssayAnswer = false,    // Flag untuk reset
    bool? isFinished,
    int? timeSpent,
    int? starsEarned,
  }) {
    return QuizState(
      level: level ?? this.level,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      isAnswered: isAnswered ?? this.isAnswered,
      selectedIndex: resetSelectedIndex ? null : (selectedIndex ?? this.selectedIndex),
      essayAnswer: resetEssayAnswer ? null : (essayAnswer ?? this.essayAnswer),
      isFinished: isFinished ?? this.isFinished,
      timeSpent: timeSpent ?? this.timeSpent,
      starsEarned: starsEarned ?? this.starsEarned,
    );
  }
}

// Kelas QuizNotifier mengelola logika interaksi kuis (timer, pemrosesan jawaban, navigasi soal).
class QuizNotifier extends StateNotifier<QuizState> {
  final Ref ref;
  Timer? _timer;

  QuizNotifier(this.ref, LevelModel rawLevel)
      : super(QuizState(level: _randomizeLevel(rawLevel))) {
    _startTimer(); // Memulai pencatatan waktu kuis
  }

  static LevelModel _randomizeLevel(LevelModel level) {
    if (level.questions.isEmpty) return level;

    // 1. Acak semua soal dari bank lalu ambil 5 saja
    final allQuestions = List<QuestionModel>.from(level.questions);
    allQuestions.shuffle(Random());
    final selectedQuestions = allQuestions.take(5).toList();

    // 2. Acak posisi Opsi (A, B, C, D) untuk setiap soal yang terpilih
    final randomizedQuestions = selectedQuestions.map((q) {
      if (q.type == QuestionType.mcq && q.options != null && q.options!.isNotEmpty) {
        final originalCorrectAnswer = q.options![q.correctAnswerIndex!];
        final shuffledOptions = List<String>.from(q.options!);
        shuffledOptions.shuffle();
        final newCorrectIndex = shuffledOptions.indexOf(originalCorrectAnswer);
        
        return QuestionModel(
          id: q.id,
          text: q.text,
          type: q.type,
          options: shuffledOptions,
          correctAnswerIndex: newCorrectIndex,
          correctAnswer: originalCorrectAnswer,
        );
      }
      return q;
    }).toList();

    return LevelModel(
      id: level.id,
      partId: level.partId,
      order: level.order,
      questions: randomizedQuestions,
    );
  }

  // Memulai timer periodik 1 detik untuk menghitung waktu pengerjaan
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isFinished) {
        state = state.copyWith(timeSpent: state.timeSpent + 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  // Memproses pilihan jawaban pada soal Pilihan Ganda (MCQ)
  void answerMCQ(int index) {
    if (state.isAnswered) return;

    final question = state.level.questions[state.currentIndex];
    final isCorrect = question.correctAnswerIndex == index;

    state = state.copyWith(
      isAnswered: true,
      selectedIndex: index,
      score: isCorrect ? state.score + 1 : state.score,
    );

    // Memberi jeda 2 detik sebelum otomatis lanjut ke soal berikutnya untuk menampilkan visual benar/salah
    Future.delayed(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  // Memproses input jawaban pada soal Essay (Uraian)
  void answerEssay(String answer) {
    if (state.isAnswered) return;

    final question = state.level.questions[state.currentIndex];
    // Validasi jawaban mengabaikan huruf kapital dan spasi di awal/akhir teks
    final isCorrect = question.correctAnswer?.toLowerCase().trim() == answer.toLowerCase().trim();

    state = state.copyWith(
      isAnswered: true,
      essayAnswer: answer,
      score: isCorrect ? state.score + 1 : state.score,
    );

    // Memberi jeda 2 detik sebelum lanjut
    Future.delayed(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  // Mengalihkan ke pertanyaan berikutnya atau menyelesaikan kuis jika sudah di akhir soal
  void nextQuestion() {
    if (state.currentIndex < state.level.questions.length - 1) {
      // PERBAIKAN: Reset semua state jawaban dengan flag
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        isAnswered: false,
        resetSelectedIndex: true,  // Reset pilihan ke null
        resetEssayAnswer: true,    // Reset essay ke null
      );
    } else {
      _finishQuiz();
    }
  }

  // Menyelesaikan kuis, menghitung pencapaian bintang berdasarkan rasio nilai dan waktu
  void _finishQuiz() {
    _timer?.cancel();
    
    // Perhitungan persentase skor kuis
    double scorePercentage = (state.score / state.level.questions.length) * 100;
    int stars = 1;

    // Logika Penghargaan Bintang:
    // - Bintang 3: Benar 5 soal (100%) dan waktu pengerjaan <= 80 detik
    // - Bintang 2: Benar 3 - 4 soal dan waktu pengerjaan <= 120 detik
    // - Bintang 1: Benar 1 - 2 soal dan waktu pengerjaan <= 140 detik
    // - Bintang 0: Salah semua (skor 0) atau waktu pengerjaan > 140 detik
    
    if (state.score == 5 && state.timeSpent <= 80) {
      stars = 3;
    } else if (state.score >= 3 && state.timeSpent <= 120) {
      stars = 2;
    } else if (state.score >= 1 && state.timeSpent <= 140) {
      stars = 1;
    } else {
      stars = 0;
    }

    // Mengirim pembaruan progres baru ke Riverpod Progress State
    ref.read(progressProvider.notifier).updateProgress(
      state.level.id,
      stars,
      state.level.partId,
    );

    state = state.copyWith(isFinished: true, starsEarned: stars);
  }

  @override
  void dispose() {
    _timer?.cancel(); // Mencegah kebocoran memori dengan membatalkan timer
    super.dispose();
  }
}

// Provider Riverpod Family untuk mendukung pemisahan state kuis berdasarkan objek LevelModel
final quizProvider = StateNotifierProvider.family<QuizNotifier, QuizState, LevelModel>((ref, level) {
  return QuizNotifier(ref, level);
});
