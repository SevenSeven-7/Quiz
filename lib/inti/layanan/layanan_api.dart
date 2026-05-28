import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import '../../model/model.dart';

/// ApiService - Service untuk mengakses data dari lokal assets
/// Mengubah mode aplikasi menjadi sepenuhnya offline
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Map<String, String> _databaseFiles = {
    'p1': 'assets/datasets/agamaislam/database-agamaislam.json',
    'p2': 'assets/datasets/bahasaindonesia/database-bahasaindonesia.json',
    'p3': 'assets/datasets/matematika/database-matematika.json',
    'p4': 'assets/datasets/ilmupengetahuanalam/database-ilmupengetahuanalam.json',
    'p5': 'assets/datasets/ilmupengetahuansosial/database-ilmupengetahuansosial.json',
    'p6': 'assets/datasets/ppkn/database-ppkn.json',
    'p7': 'assets/datasets/bahasainggris/database-bahasainggris.json',
  };

  /// Get 5 questions untuk level tertentu secara terstruktur (offline)
  Future<List<QuestionModel>> getQuestionsForLevel(String partId, int levelNumber) async {
    try {
      if (!_databaseFiles.containsKey(partId)) return [];
      
      final String jsonString = await rootBundle.loadString(_databaseFiles[partId]!);
      final List<dynamic> questionsJson = json.decode(jsonString);
      
      if (questionsJson.isEmpty) return [];

      // Mengambil 5 soal secara deterministik berdasarkan levelNumber.
      // Menggunakan modulo (%) agar tetap aman (wrap-around) jika nomor level melebihi jumlah soal.
      final int startIndex = ((levelNumber - 1) * 5) % questionsJson.length;
      final List<dynamic> selectedJson = [];
      for (int i = 0; i < 5; i++) {
        selectedJson.add(questionsJson[(startIndex + i) % questionsJson.length]);
      }
      
      return selectedJson.map((json) {
        // Shuffle options for MCQ
        List<String>? options;
        int correctIndex = json['correctAnswerIndex'] ?? 0;
        
        if (json['type'] != 'essay' && json['options'] != null) {
          options = List<String>.from(json['options']);
          String correctAnswer = options[correctIndex];
          options.shuffle(Random());
          correctIndex = options.indexOf(correctAnswer);
        }

        return QuestionModel(
          id: json['id'] ?? '',
          text: json['text'] ?? '',
          type: json['type'] == 'essay' ? QuestionType.essay : QuestionType.mcq,
          options: options,
          correctAnswerIndex: correctIndex,
          correctAnswer: json['correctAnswer'] ?? '',
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching local questions for $partId: $e');
      return [];
    }
  }

  /// Get all subjects/parts
  Future<List<PartModel>> getParts() async {
    // Karena ini offline, kita bisa mengembalikan parts secara langsung (hardcoded offline parts)
    return _getDefaultParts();
  }

  /// Get levels untuk subject tertentu
  Future<List<LevelModel>> getLevels(String partId) async {
    // Generate 100 level untuk setiap mata pelajaran
    return List.generate(100, (index) {
      final levelNumber = index + 1;
      return LevelModel(
        id: '${partId}_l$levelNumber',
        order: levelNumber,
        partId: partId,
        questions: [], // Akan diisi saat level dimainkan
      );
    });
  }

  /// Check health / app is running locally
  Future<bool> checkHealth() async {
    // Selalu sehat karena berjalan lokal
    return true;
  }

  /// Get statistics
  Future<Map<String, dynamic>> getStats() async {
    // Hardcoded stats karena data sudah fix di assets untuk offline
    return {
        "total_subjects": 7,
        "total_questions": 7000,
        "questions_per_subject": {
          "p1": 1000,
          "p2": 1000,
          "p3": 1000,
          "p4": 1000,
          "p5": 1000,
          "p6": 1000,
          "p7": 1000
        }
    };
  }

  /// Default parts jika API tidak tersedia / berjalan secara lokal
  List<PartModel> _getDefaultParts() {
    return [
      PartModel(id: 'p1', title: 'Bagian 1: Agama Islam', description: 'Pelajari rukun iman, shalat, dan nabi.'),
      PartModel(id: 'p2', title: 'Bagian 2: Bahasa Indonesia', description: 'Tata bahasa, EYD, dan kosa kata.'),
      PartModel(id: 'p3', title: 'Bagian 3: Matematika', description: 'Logika berhitung, aljabar, dan angka.'),
      PartModel(id: 'p4', title: 'Bagian 4: Ilmu Pengetahuan Alam', description: 'Fisika, biologi, dan alam semesta.'),
      PartModel(id: 'p5', title: 'Bagian 5: Ilmu Pengetahuan Sosial', description: 'Sejarah pahlawan, dan geografi.'),
      PartModel(id: 'p6', title: 'Bagian 6: PPKn', description: 'Pancasila, UUD 1945, dan negara.'),
      PartModel(id: 'p7', title: 'Bagian 7: Bahasa Inggris', description: 'Vocabulary, grammar, dan dasar.'),
    ];
  }
}
