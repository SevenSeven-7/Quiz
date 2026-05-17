import 'dart:convert';
import 'package:flutter/services.dart';
import '../../model/model.dart';

// Kelas DataService bertanggung jawab memuat data kuis dari file JSON lokal di aset.
class DataService {
  // Membaca file kuis 'questions.json' dari folder assets dan mendekodekannya menjadi Map.
  Future<Map<String, dynamic>> loadQuizData() async {
    final String response = await rootBundle.loadString('assets/data/questions.json');
    return json.decode(response);
  }

  // Mengambil daftar Bagian (PartModel) dari file JSON lokal.
  Future<List<PartModel>> getParts() async {
    final data = await loadQuizData();
    return (data['parts'] as List).map((p) => PartModel(
      id: p['id'],
      title: p['title'],
      description: p['description'],
      isLocked: p['isLocked'] ?? false,
    )).toList();
  }

  // Mengambil daftar Level (LevelModel) berdasarkan ID bagian tertentu.
  Future<List<LevelModel>> getLevels(String partId) async {
    final data = await loadQuizData();
    return (data['levels'] as List)
        .where((l) => l['partId'] == partId)
        .map((l) => LevelModel(
              id: l['id'],
              partId: l['partId'],
              order: l['order'],
              questions: (l['questions'] as List)
                  .map((q) => QuestionModel.fromJson(q))
                  .toList(),
            ))
        .toList();
  }
}
