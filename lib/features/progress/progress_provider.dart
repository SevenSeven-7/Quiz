import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';

class ProgressState {
  final Map<String, int> levelStars; // levelId -> stars
  final Map<String, bool> unlockedLevels; // levelId -> isUnlocked
  final Set<String> unlockedParts; // partId

  ProgressState({
    required this.levelStars,
    required this.unlockedLevels,
    required this.unlockedParts,
  });

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

class ProgressNotifier extends StateNotifier<ProgressState> {
  ProgressNotifier() : super(ProgressState(
    levelStars: {},
    unlockedLevels: {'p1_l1': true}, // Level 1 Bagian 1 selalu terbuka
    unlockedParts: {'p1'}, // Bagian 1 selalu terbuka
  ));

  void updateProgress(String levelId, int stars, String partId) {
    final newStars = Map<String, int>.from(state.levelStars);
    if ((newStars[levelId] ?? 0) < stars) {
      newStars[levelId] = stars;
    }

    // Logika Unlock Level Berikutnya
    final newUnlocked = Map<String, bool>.from(state.unlockedLevels);
    final currentLevelNum = int.parse(levelId.split('_l')[1]);
    final nextLevelId = '${partId}_l${currentLevelNum + 1}';
    
    // Asumsi maksimal 100 level
    if (currentLevelNum < 100) {
      newUnlocked[nextLevelId] = true;
    }

    state = state.copyWith(
      levelStars: newStars,
      unlockedLevels: newUnlocked,
    );

    _checkPartUnlock();
  }

  void _checkPartUnlock() {
    // Hitung rata-rata skor Bagian 1
    int totalStars = 0;
    int completedLevels = 0;
    
    state.levelStars.forEach((id, stars) {
      if (id.startsWith('p1')) {
        totalStars += stars;
        completedLevels++;
      }
    });

    // Syarat unlock Bagian 2: Misal rata-rata bintang > 2.5 atau total level selesai cukup banyak
    // Sesuai instruksi: 90% skor. Jika 1 level 10 soal, 100 level 1000 soal.
    // Kita bisa simpan skor mentah juga nanti. Untuk sekarang gunakan logika bintang.
    if (completedLevels >= 1 && !state.unlockedParts.contains('p2')) {
       // Cek persentase keberhasilan (simulasi)
       // Di produksi nanti, kita akan hitung dari total skor asli
       if (totalStars >= (completedLevels * 2.7)) { // Simulasi 90% dengan bintang
         final newParts = Set<String>.from(state.unlockedParts);
         newParts.add('p2');
         final newUnlocked = Map<String, bool>.from(state.unlockedLevels);
         newUnlocked['p2_l1'] = true;
         state = state.copyWith(unlockedParts: newParts, unlockedLevels: newUnlocked);
       }
    }
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier();
});
