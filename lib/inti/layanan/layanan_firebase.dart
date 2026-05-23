import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../model/model.dart';
import 'layanan_data.dart';

// Kelas FirebaseService mengelola interaksi sinkronisasi data online menggunakan Firebase Firestore.
class FirebaseService {
  final DataService _localData = DataService();

  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool get _isFirebaseAvailable {
    try {
      Firebase.app();
      return true;
    } catch (_) {
      return false;
    }
  }

  // Mengambil soal acak dari Firebase
  Future<List<QuestionModel>> getQuestionsForLevel(String partId) async {
    if (!_isFirebaseAvailable) return [];

    try {
      // Ambil angka acak dari 0 hingga 1.000.000
      final randomKey = Random().nextInt(1000000);
      
      var query = await FirebaseFirestore.instance
          .collection('questions_pool')
          .where('partId', isEqualTo: partId)
          .where('random_key', isGreaterThanOrEqualTo: randomKey)
          .limit(10)
          .get();

      // Fallback jika tidak menemukan data di atas batas random_key
      if (query.docs.length < 10) {
        query = await FirebaseFirestore.instance
            .collection('questions_pool')
            .where('partId', isEqualTo: partId)
            .where('random_key', isLessThan: randomKey)
            .limit(10)
            .get();
      }

      return query.docs.map((d) {
        final data = d.data();
        
        // Handle opsi secara aman
        List<String>? parsedOptions;
        if (data['options'] != null) {
          if (data['options'] is List) {
            parsedOptions = List<String>.from(data['options']);
          } else if (data['options'] is Map) {
            // Berjaga-jaga jika terformat mentah sebagai Map dari REST API
            final mapOpts = data['options'] as Map;
            if (mapOpts.containsKey('values')) {
              parsedOptions = List<String>.from((mapOpts['values'] as List).map((e) => e['stringValue'] ?? e));
            }
          }
        }

        return QuestionModel(
          id: data['id'] ?? '',
          text: data['text'] ?? '',
          type: data['type'] == 'essay' ? QuestionType.essay : QuestionType.mcq,
          options: parsedOptions,
          correctAnswerIndex: data['correctAnswerIndex'],
          correctAnswer: data['correctAnswer'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching random questions: $e');
      return [];
    }
  }

  Future<List<PartModel>> getParts() async {
    return _localData.getParts();
  }

  Future<List<LevelModel>> getLevels(String partId) async {
    return _localData.getLevels(partId);
  }
}
