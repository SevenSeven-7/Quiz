import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../model/model.dart';
import 'layanan_data.dart';

// Kelas FirebaseService mengelola interaksi sinkronisasi data online menggunakan Firebase Firestore.
class FirebaseService {
  final DataService _localData = DataService();

  // Penerapan pola Singleton untuk memastikan hanya ada satu instansi FirebaseService di seluruh aplikasi.
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Memeriksa apakah inisialisasi Firebase berhasil dan siap digunakan.
  bool get _isFirebaseAvailable {
    try {
      Firebase.app();
      return true;
    } catch (_) {
      return false;
    }
  }

  // Mengunggah data lokal (seeding) ke Firestore secara otomatis jika Firestore masih kosong.
  Future<void> seedDataIfNeeded() async {
    if (!_isFirebaseAvailable) return;

    try {
      final partsSnapshot = await FirebaseFirestore.instance.collection('parts').limit(1).get();
      if (partsSnapshot.docs.isNotEmpty) {
        // Data sudah ada di Firestore, tidak perlu seeding lagi
        return;
      }

      // 1. Ambil data lokal
      final parts = await _localData.getParts();
      
      // 2. Upload Bagian (parts)
      for (var part in parts) {
        await FirebaseFirestore.instance.collection('parts').doc(part.id).set({
          'title': part.title,
          'description': part.description,
          'isLocked': part.isLocked,
        });

        // 3. Ambil levels lokal untuk bagian ini
        final levels = await _localData.getLevels(part.id);
        
        // 4. Upload Levels
        for (var level in levels) {
          final questionsData = level.questions.map((q) {
            return {
              'id': q.id,
              'text': q.text,
              'type': q.type == QuestionType.essay ? 'essay' : 'mcq',
              'options': q.options,
              'correctAnswerIndex': q.correctAnswerIndex,
              'correctAnswer': q.correctAnswer,
            };
          }).toList();

          await FirebaseFirestore.instance.collection('levels').doc(level.id).set({
            'partId': level.partId,
            'order': level.order,
            'questions': questionsData,
          });
        }
      }
    } catch (e) {
      // Gagal seeding secara diam-diam agar aplikasi tidak crash
      debugPrint('Gagal melakukan seeding data Firebase: $e');
    }
  }

  // Mengambil daftar Bagian (PartModel) dari Firebase Firestore. 
  // Jika Firebase tidak tersedia atau terjadi error, otomatis menggunakan data lokal.
  Future<List<PartModel>> getParts() async {
    // Memaksa selalu menggunakan data lokal agar pembaruan JSON terbaru langsung terbaca
    return _localData.getParts();
  }

  // Mengambil daftar Level kuis berdasarkan ID bagian dari Firebase Firestore.
  // Jika offline atau terjadi kegagalan koneksi, data akan dimuat dari penyimpanan lokal JSON.
  Future<List<LevelModel>> getLevels(String partId) async {
    // Selalu gunakan data lokal agar tidak ada jeda loading dan soal terbaru langsung terbaca
    return _localData.getLevels(partId);
  }
}
