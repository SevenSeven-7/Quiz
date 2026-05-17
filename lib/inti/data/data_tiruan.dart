import '../../model/model.dart';

// Kelas MockData menyediakan data tiruan/simulasi kuis untuk keperluan pengujian.
class MockData {
  // Daftar kategori kuis tiruan
  static List<CategoryModel> categories = [
    CategoryModel(id: '1', name: 'Sains', icon: '🔬'),
    CategoryModel(id: '2', name: 'Teknologi', icon: '💻'),
    CategoryModel(id: '3', name: 'Sejarah', icon: '📜'),
    CategoryModel(id: '4', name: 'Geografi', icon: '🌍'),
  ];

  // Daftar pertanyaan kuis tiruan beserta pilihan jawaban dan indeks jawaban yang benar
  static List<QuestionModel> questions = [
    QuestionModel(
      id: '1',
      categoryId: '1',
      text: 'Apa planet terbesar di tata surya kita?',
      options: ['Bumi', 'Mars', 'Jupiter', 'Saturnus'],
      correctAnswerIndex: 2,
    ),
    QuestionModel(
      id: '2',
      categoryId: '1',
      text: 'Zat yang memberikan warna hijau pada daun adalah?',
      options: ['Klorofil', 'Hemoglobin', 'Melanin', 'Karoten'],
      correctAnswerIndex: 0,
    ),
    QuestionModel(
      id: '3',
      categoryId: '2',
      text: 'Siapa penemu World Wide Web (WWW)?',
      options: ['Steve Jobs', 'Bill Gates', 'Tim Berners-Lee', 'Elon Musk'],
      correctAnswerIndex: 2,
    ),
    // Tambahkan lebih banyak soal jika diperlukan di masa mendatang
  ];
}
