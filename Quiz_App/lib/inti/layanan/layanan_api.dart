import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../model/model.dart';

/// ApiService - Service untuk mengakses Python API
/// Menggantikan Firebase dengan Python backend
class ApiService {
  // Base URL API - GANTI IP INI SESUAI IP PC ANDA
  // Untuk development di PC: http://localhost:5000
  // Untuk HP/device lain: http://192.168.100.14:5000 (ganti dengan IP PC Anda)
  static const String baseUrl = 'http://192.168.100.14:5000';
  
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Get 10 random questions untuk level tertentu
  Future<List<QuestionModel>> getQuestionsForLevel(String partId, int levelNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/questions/$partId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          final List<dynamic> questionsJson = data['data'];
          
          return questionsJson.map((json) {
            return QuestionModel(
              id: json['id'] ?? '',
              text: json['text'] ?? '',
              type: json['type'] == 'essay' ? QuestionType.essay : QuestionType.mcq,
              options: json['options'] != null ? List<String>.from(json['options']) : null,
              correctAnswerIndex: json['correctAnswerIndex'],
              correctAnswer: json['correctAnswer'],
            );
          }).toList();
        }
      }
      
      debugPrint('Error fetching questions: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('Error fetching questions for $partId: $e');
      return [];
    }
  }

  /// Get all subjects/parts
  Future<List<PartModel>> getParts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subjects'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          final List<dynamic> subjectsJson = data['data'];
          
          return subjectsJson.map((json) {
            return PartModel(
              id: json['id'] ?? '',
              title: 'Bagian ${json['id'].substring(1)}: ${json['name']}',
              description: json['description'] ?? '',
            );
          }).toList();
        }
      }
      
      debugPrint('Error fetching subjects: ${response.statusCode}');
      return _getDefaultParts();
    } catch (e) {
      debugPrint('Error fetching subjects: $e');
      return _getDefaultParts();
    }
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

  /// Check API health
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'healthy';
      }
      
      return false;
    } catch (e) {
      debugPrint('Health check failed: $e');
      return false;
    }
  }

  /// Get statistics
  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          return data['data'];
        }
      }
      
      return {};
    } catch (e) {
      debugPrint('Error fetching stats: $e');
      return {};
    }
  }

  /// Default parts jika API tidak tersedia
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
