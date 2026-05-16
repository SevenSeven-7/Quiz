# Blueprint Pengembangan Aplikasi Quiz (Versi 2.0)

Aplikasi **Quiz** adalah platform asah otak berbasis level yang menantang pemain untuk menyelesaikan tantangan bertahap dari Bagian 1 (Bahasa Indonesia) menuju Bagian 2 (Matematika).

## 1. Identitas & Tema
*   **Nama Aplikasi**: Quiz
*   **Tema**: Elegant Dark Mode (Onyx Black, Electric Violet).
*   **Target**: 100 Level per Bagian.

## 2. Arsitektur Sistem
*   **Framework**: Flutter
*   **State Management**: Riverpod (untuk progres level dan state kuis).
*   **Database**: Firebase Firestore (Data soal) + Local JSON (Backup).
*   **Pola Desain**: MVVM (Model-View-ViewModel).

## 3. Fitur Utama & Logika Permainan

### A. Struktur Konten
*   **Bagian 1 (Quiz Bahasa Indonesia)**: 100 Level.
*   **Bagian 2 (Quiz Matematika)**: 100 Level (Terkunci di awal).
*   **Komposisi Level**: 10 Soal per level.
    *   8 Soal Pilihan Ganda (A, B, C, D).
    *   2 Soal Uraian (Berada di nomor 5 dan nomor 10).

### B. Mekanisme Progres
*   **Unlock Level**: Level `n+1` terbuka hanya jika Level `n` selesai.
*   **Rating Bintang**: 
    *   3 Bintang: Selesai dengan waktu sangat cepat.
    *   2 Bintang: Selesai dengan waktu rata-rata.
    *   1 Bintang: Selesai mendekati batas waktu.
*   **Unlock Bagian 2**: 
    *   Syarat: Total skor Bagian 1 harus mencapai minimal **90%**.
    *   Jika skor < 90%, pemain harus mengulang level tertentu untuk memperbaiki skor.

### C. Alur Pengguna (User Flow)
1.  **Splash Screen**: Animasi logo "Q" biru.
2.  **Home Screen**: Pilihan Bagian (Bagian 1 & 2).
3.  **Level Selection**: Grid level 1-100 dengan indikator bintang dan status kunci.
4.  **Quiz Screen**: 
    *   Slide 1-4, 6-9: Pilihan Ganda.
    *   Slide 5 & 10: Input Text (Uraian).
    *   Timer berjalan di atas.
5.  **Result Screen**: Perolehan bintang, skor, dan tombol "Level Berikutnya".

## 4. Struktur Data (Firestore)
*   **Collection: `parts`** -> `partId`, `title`.
*   **Collection: `levels`** -> `levelId`, `partId`, `order`.
*   **Collection: `questions`** -> `id`, `levelId`, `type` (mcq/essay), `text`, `options`, `answer`.

## 5. Rencana Pengembangan
1.  Setup Firebase Core & Firestore.
2.  Refactor Model (Part, Level, Question).
3.  Implementasi `ProgressNotifier` (State Management).
4.  Update UI (Home, Level Selection, Quiz MCQ/Essay).
5.  Integrasi Timer & Logic Bintang.
6.  Sistem Unlock Bagian 2.
