// Enumerasi untuk menentukan jenis pertanyaan kuis (Pilihan Ganda atau Essay).
enum QuestionType { mcq, essay }

// Model data untuk objek Pertanyaan Kuis.
class QuestionModel {
  final String id; // ID unik pertanyaan
  final String text; // Teks pertanyaan kuis
  final QuestionType type; // Tipe kuis (mcq atau essay)
  final List<String>? options; // Daftar opsi jawaban (Khusus untuk Pilihan Ganda / MCQ)
  final int? correctAnswerIndex; // Indeks jawaban benar (Khusus untuk Pilihan Ganda / MCQ)
  final String? correctAnswer; // Teks jawaban benar (Khusus untuk Essay / Uraian)

  QuestionModel({
    required this.id,
    required this.text,
    required this.type,
    this.options,
    this.correctAnswerIndex,
    this.correctAnswer,
  });

  // Dekoding objek QuestionModel dari format JSON.
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      text: json['text'],
      type: json['type'] == 'essay' ? QuestionType.essay : QuestionType.mcq,
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      correctAnswerIndex: json['correctAnswerIndex'],
      correctAnswer: json['correctAnswer'],
    );
  }
}

// Model data untuk mewakili Level/Tingkat kuis.
class LevelModel {
  final String id; // ID unik level (format: partId_lLevelNumber)
  final int order; // Nomor urutan level
  final String partId; // ID bagian tempat level ini berada
  final List<QuestionModel> questions; // Daftar pertanyaan dalam level ini
  final int stars; // Jumlah bintang yang diperoleh (0, 1, 2, atau 3)
  final bool isUnlocked; // Apakah level ini sudah terbuka untuk dimainkan

  LevelModel({
    required this.id,
    required this.order,
    required this.partId,
    required this.questions,
    this.stars = 0,
    this.isUnlocked = false,
  });
}

// Model data untuk mewakili Bagian utama kuis (Kategori/Sesi).
class PartModel {
  final String id; // ID unik bagian (misal: p1, p2)
  final String title; // Judul bagian (contoh: Bagian 1: Quiz Bahasa Indonesia)
  final String description; // Penjelasan singkat isi bagian
  final bool isLocked; // Status penguncian bagian
  final double progress; // Persentase kemajuan belajar pemain (0.0 sampai 1.0)

  PartModel({
    required this.id,
    required this.title,
    required this.description,
    this.isLocked = false,
    this.progress = 0.0,
  });

  // Mengembalikan judul kuis tanpa prefiks "Bagian X: "
  String get cleanTitle {
    return title.replaceAll(RegExp(r'^Bagian\s+\d+\s*:\s*', caseSensitive: false), '');
  }
}

// Model data untuk informasi Profil Pengguna/Pemain.
class UserModel {
  final String uid; // ID unik user Firebase/Guest
  final String username; // Nama tampilan pemain
  final int totalScore; // Total akumulasi skor kuis
  final DateTime joinDate; // Tanggal mulai bergabung

  UserModel({
    required this.uid,
    required this.username,
    required this.totalScore,
    required this.joinDate,
  });

  // Nilai inisialisasi awal untuk tamu/guest pemain baru.
  factory UserModel.initial() {
    return UserModel(
      uid: 'guest',
      username: 'Pemain',
      totalScore: 0,
      joinDate: DateTime.now(),
    );
  }
}

// Model data tambahan untuk Kategori (jika dibutuhkan di masa depan).
class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });
}
