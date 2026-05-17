import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/model.dart';

// Kelas ProgressState menampung data status kemajuan bermain kuis (skor bintang dan level yang terbuka).
class ProgressState {
  // Pemetaan dari levelId ke jumlah bintang yang diperoleh (levelId -> bintang)
  final Map<String, int> levelStars;
  
  // Pemetaan dari levelId ke status apakah level tersebut terkunci/terbuka (levelId -> terbuka)
  final Map<String, bool> unlockedLevels;
  
  // Kumpulan ID bagian kuis yang sudah berhasil terbuka
  final Set<String> unlockedParts;

  ProgressState({
    required this.levelStars,
    required this.unlockedLevels,
    required this.unlockedParts,
  });

  // Total bintang yang berhasil dikumpulkan pemain
  int get totalStars {
    int total = 0;
    levelStars.forEach((key, value) => total += value);
    return total;
  }

  // Menentukan gelar kecerdasan berdasarkan perolehan bintang
  String get gelarKecerdasan {
    final stars = totalStars;
    if (stars <= 15) return 'Calon Juara';
    if (stars <= 60) return 'Pencari Ilmu';
    if (stars <= 150) return 'Pelajar Tangguh';
    if (stars <= 300) return 'Pikir Cepat';
    if (stars <= 450) return 'Cerdas Cermat';
    if (stars <= 570) return 'Master Kuis';
    return 'Genius Sejati';
  }

  // Menentukan warna representasi untuk gelar kecerdasan
  Color get warnaGelar {
    final stars = totalStars;
    if (stars <= 15) return const Color(0xFF95A5A6); // Abu-abu
    if (stars <= 60) return const Color(0xFF3498DB); // Biru muda
    if (stars <= 150) return const Color(0xFF2ECC71); // Hijau
    if (stars <= 300) return const Color(0xFF9B59B6); // Ungu
    if (stars <= 450) return const Color(0xFFE67E22); // Oranye tembaga
    if (stars <= 570) return const Color(0xFFF1C40F); // Kuning emas
    return const Color(0xFFE74C3C); // Merah membara
  }

  // Jumlah level Bahasa Indonesia (Bagian 1) yang berhasil diselesaikan
  int get indonesianSolved {
    return levelStars.keys.where((k) => k.startsWith('p1_l') && (levelStars[k] ?? 0) > 0).length;
  }

  // Jumlah level Matematika (Bagian 2) yang berhasil diselesaikan
  int get mathSolved {
    return levelStars.keys.where((k) => k.startsWith('p2_l') && (levelStars[k] ?? 0) > 0).length;
  }

  // Metode untuk menyalin status kemajuan dengan beberapa perubahan (copyWith pattern)
  ProgressState copyWith({
    Map<String, int>? levelStars,
    Map<String, bool>? unlockedLevels,
    Set<String>? unlockedParts,
  }) {
    return ProgressState(
      levelStars: levelStars ?? this.levelStars,
      unlockedLevels: unlockedLevels ?? this.unlockedLevels,
      unlockedParts: unlockedParts ?? this.unlockedParts,
    );
  }
}

// Kelas ProgressNotifier mengontrol perubahan status progres belajar secara dinamis.
class ProgressNotifier extends StateNotifier<ProgressState> {
  ProgressNotifier() : super(ProgressState(
    levelStars: {},
    unlockedLevels: {'p1_l1': true, 'p2_l1': true}, // Level 1 di Bagian 1 dan Bagian 2 selalu terbuka bawaan
    unlockedParts: {'p1', 'p2'}, // Bagian 1 dan Bagian 2 selalu terbuka bawaan
  ));

  // Fungsi untuk memperbarui progres ketika suatu level kuis diselesaikan
  void updateProgress(String levelId, int stars, String partId) {
    final newStars = Map<String, int>.from(state.levelStars);
    
    // Simpan perolehan bintang jika tingkat level ini belum pernah diselesaikan, atau perolehan bintang baru lebih tinggi
    if (!newStars.containsKey(levelId) || newStars[levelId]! < stars) {
      newStars[levelId] = stars;
    }

    // Logika membuka (unlock) level kuis berikutnya secara otomatis
    final newUnlocked = Map<String, bool>.from(state.unlockedLevels);
    final currentLevelNum = int.parse(levelId.split('_l')[1]);
    final nextLevelId = '${partId}_l${currentLevelNum + 1}';
    
    // Mengasumsikan maksimal tingkat adalah 100 level kuis
    if (currentLevelNum < 100) {
      newUnlocked[nextLevelId] = true;
    }

    state = state.copyWith(
      levelStars: newStars,
      unlockedLevels: newUnlocked,
    );
  }
}

// Provider Riverpod untuk mendistribusikan status kemajuan (progressProvider) ke seluruh widget.
final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier();
});
