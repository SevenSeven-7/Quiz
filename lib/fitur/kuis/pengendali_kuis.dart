import 'dart:async';
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
    String? essayAnswer,
    bool? isFinished,
    int? timeSpent,
    int? starsEarned,
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
      starsEarned: starsEarned ?? this.starsEarned,
    );
  }
}

// Kelas QuizNotifier mengelola logika interaksi kuis (timer, pemrosesan jawaban, navigasi soal).
class QuizNotifier extends StateNotifier<QuizState> {
  final Ref ref;
  Timer? _timer;

  QuizNotifier(this.ref, LevelModel level)
      : super(QuizState(level: level)) {
    _startTimer(); // Memulai pencatatan waktu kuis
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

  // Menyelesaikan kuis, menghitung pencapaian bintang berdasarkan rasio nilai dan waktu
  void _finishQuiz() {
    _timer?.cancel();
    
    // Perhitungan persentase skor kuis
    double scorePercentage = (state.score / state.level.questions.length) * 100;
    int stars = 1;

    // Logika Penghargaan Bintang:
    // - Bintang 3: Skor >= 90% dan waktu pengerjaan <= 60 detik
    // - Bintang 2: Skor >= 70% dan waktu pengerjaan <= 90 detik
    // - Bintang 1: Skor >= 50%
    // - Bintang 0: Skor di bawah 50% (tidak lulus)
    if (scorePercentage >= 90 && state.timeSpent <= 60) {
      stars = 3;
    } else if (scorePercentage >= 70 && state.timeSpent <= 90) {
      stars = 2;
    } else if (scorePercentage >= 50) {
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
