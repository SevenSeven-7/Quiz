import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../models/models.dart';
import 'data_service.dart';

class FirebaseService {
  final DataService _localData = DataService();

  // Singleton
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

  Future<List<PartModel>> getParts() async {
    if (!_isFirebaseAvailable) {
      return _localData.getParts();
    }

    try {
      final snapshot = await FirebaseFirestore.instance.collection('parts').get();
      
      if (snapshot.docs.isEmpty) {
        return _localData.getParts();
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PartModel(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          isLocked: data['isLocked'] ?? false,
        );
      }).toList();
    } catch (e) {
      return _localData.getParts();
    }
  }

  Future<List<LevelModel>> getLevels(String partId) async {
    if (!_isFirebaseAvailable) {
      return _localData.getLevels(partId);
    }

    try {
      final snapshot = await FirebaseFirestore.instance.collection('levels')
          .where('partId', isEqualTo: partId)
          .get();

      if (snapshot.docs.isEmpty) {
        return _localData.getLevels(partId);
      }

      final List<LevelModel> levels = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final List questionsRaw = data['questions'] ?? [];
        final questions = questionsRaw.map((q) => QuestionModel.fromJson(Map<String, dynamic>.from(q))).toList();

        levels.add(LevelModel(
          id: doc.id,
          partId: data['partId'] ?? partId,
          order: data['order'] ?? 0,
          questions: questions,
        ));
      }
      
      levels.sort((a, b) => a.order.compareTo(b.order));
      return levels;
    } catch (e) {
      return _localData.getLevels(partId);
    }
  }
}
