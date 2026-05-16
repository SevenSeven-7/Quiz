import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/models.dart';

class DataService {
  Future<Map<String, dynamic>> loadQuizData() async {
    final String response = await rootBundle.loadString('assets/data/questions.json');
    return json.decode(response);
  }

  Future<List<PartModel>> getParts() async {
    final data = await loadQuizData();
    return (data['parts'] as List).map((p) => PartModel(
      id: p['id'],
      title: p['title'],
      description: p['description'],
      isLocked: p['isLocked'] ?? false,
    )).toList();
  }

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
