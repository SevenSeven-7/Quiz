import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (stars <= 570) return 'Master Quiz';
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

  int get islamicSolved => levelStars.keys.where((k) => k.startsWith('p1_l') && (levelStars[k] ?? 0) > 0).length;
  int get indonesianSolved => levelStars.keys.where((k) => k.startsWith('p2_l') && (levelStars[k] ?? 0) > 0).length;
  int get mathSolved => levelStars.keys.where((k) => k.startsWith('p3_l') && (levelStars[k] ?? 0) > 0).length;
  int get ipaSolved => levelStars.keys.where((k) => k.startsWith('p4_l') && (levelStars[k] ?? 0) > 0).length;
  int get ipsSolved => levelStars.keys.where((k) => k.startsWith('p5_l') && (levelStars[k] ?? 0) > 0).length;
  int get ppknSolved => levelStars.keys.where((k) => k.startsWith('p6_l') && (levelStars[k] ?? 0) > 0).length;
  int get englishSolved => levelStars.keys.where((k) => k.startsWith('p7_l') && (levelStars[k] ?? 0) > 0).length;

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
  )) {
    _loadProgress();
  }

  // Fungsi internal untuk memuat data progres yang disimpan secara lokal
  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Memuat levelStars lokal
      final starsJson = prefs.getString('quiz_level_stars');
      Map<String, int> loadedStars = {};
      if (starsJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(starsJson);
        loadedStars = decoded.map((key, value) => MapEntry(key, value as int));
      }

      // Memuat unlockedLevels lokal
      final unlockedJson = prefs.getString('quiz_unlocked_levels');
      Map<String, bool> loadedUnlocked = {'p1_l1': true, 'p2_l1': true};
      if (unlockedJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(unlockedJson);
        loadedUnlocked.addAll(decoded.map((key, value) => MapEntry(key, value as bool)));
      }

      // Memuat unlockedParts lokal
      final partsJson = prefs.getString('quiz_unlocked_parts');
      Set<String> loadedParts = {'p1', 'p2'};
      if (partsJson != null) {
        final List<dynamic> decoded = jsonDecode(partsJson);
        loadedParts.addAll(decoded.map((e) => e as String));
      }

      state = ProgressState(
        levelStars: loadedStars,
        unlockedLevels: loadedUnlocked,
        unlockedParts: loadedParts,
      );
    } catch (e) {
      debugPrint('Gagal memuat progres kuis secara lokal $e');
    }
  }

  // Fungsi untuk memperbarui progres ketika suatu level kuis diselesaikan
  Future<void> updateProgress(String levelId, int stars, String partId) async {
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

    // Simpan progres terbaru secara lokal
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('quiz_level_stars', jsonEncode(state.levelStars));
      await prefs.setString('quiz_unlocked_levels', jsonEncode(state.unlockedLevels));
      await prefs.setString('quiz_unlocked_parts', jsonEncode(state.unlockedParts.toList()));
    } catch (e) {
      debugPrint('Gagal menyimpan progres kuis baru $e');
    }
  }

  // Fungsi untuk mereset seluruh progres kuis ke keadaan awal
  Future<void> resetProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('quiz_level_stars');
      await prefs.remove('quiz_unlocked_levels');
      await prefs.remove('quiz_unlocked_parts');

      state = ProgressState(
        levelStars: {},
        unlockedLevels: {'p1_l1': true, 'p2_l1': true},
        unlockedParts: {'p1', 'p2'},
      );
    } catch (e) {
      debugPrint('Gagal mereset progres kuis $e');
    }
  }

  // Fungsi untuk menghapus seluruh data akun pemain secara permanen
  Future<void> deleteAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Hapus seluruh data lokal
      await prefs.remove('player_name');
      await prefs.clear();

      // Reset state ke kondisi awal
      state = ProgressState(
        levelStars: {},
        unlockedLevels: {'p1_l1': true, 'p2_l1': true},
        unlockedParts: {'p1', 'p2'},
      );
    } catch (e) {
      debugPrint('Gagal menghapus akun $e');
    }
  }
}

// Provider Riverpod untuk mendistribusikan status kemajuan (progressProvider) ke seluruh widget.
final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier();
});
