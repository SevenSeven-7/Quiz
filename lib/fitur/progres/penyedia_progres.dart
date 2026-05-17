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
    unlockedLevels: {'p1_l1': true}, // Level 1 Bagian 1 selalu terbuka secara bawaan
    unlockedParts: {'p1'}, // Bagian 1 selalu terbuka secara bawaan
  ));

  // Fungsi untuk memperbarui progres ketika suatu level kuis diselesaikan
  void updateProgress(String levelId, int stars, String partId) {
    final newStars = Map<String, int>.from(state.levelStars);
    
    // Hanya simpan perolehan bintang jika lebih tinggi dari rekor sebelumnya
    if ((newStars[levelId] ?? 0) < stars) {
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

    // Evaluasi apakah kriteria pembukaan Bagian 2 (Matematika) telah terpenuhi
    _checkPartUnlock();
  }

  // Fungsi internal untuk mengevaluasi pembukaan bagian baru
  void _checkPartUnlock() {
    int totalStars = 0;
    int completedLevels = 0;
    
    // Menghitung perolehan bintang kumulatif di Bagian 1 (Bahasa Indonesia)
    state.levelStars.forEach((id, stars) {
      if (id.startsWith('p1')) {
        totalStars += stars;
        completedLevels++;
      }
    });

    // Syarat membuka Bagian 2: Minimal telah menyelesaikan level dan memenuhi skor simulasi bintang 90%
    if (completedLevels >= 1 && !state.unlockedParts.contains('p2')) {
       // Persentase keberhasilan dihitung dengan simulasi bintang (rata-rata bintang >= 2.7)
       if (totalStars >= (completedLevels * 2.7)) {
          final newParts = Set<String>.from(state.unlockedParts);
          newParts.add('p2');
          
          final newUnlocked = Map<String, bool>.from(state.unlockedLevels);
          newUnlocked['p2_l1'] = true; // Otomatis membuka Level 1 di Bagian 2
          
          state = state.copyWith(unlockedParts: newParts, unlockedLevels: newUnlocked);
       }
    }
  }
}

// Provider Riverpod untuk mendistribusikan status kemajuan (progressProvider) ke seluruh widget.
final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier();
});
