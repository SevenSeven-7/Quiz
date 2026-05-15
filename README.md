# Quiz - Aplikasi Kuis Cerdas 🧠

Quiz adalah aplikasi mobile berbasis Flutter yang dirancang untuk memberikan pengalaman bermain kuis (trivia) yang elegan, responsif, dan menantang. Dibangun dengan fokus pada *User Experience* (UX) yang bersih dan tanpa gangguan.

## 📋 Daftar Fitur

1.  **Kategori Multidimensi:** Pilihan bank soal berdasarkan berbagai topik (Sains, Teknologi, Sejarah, dll).
2.  **Sistem Validasi Real-time:** Memberikan umpan balik visual instan (hijau/merah) segera setelah pengguna memilih jawaban.
3.  **Dynamic Scoring:** Penghitungan skor yang tidak hanya bergantung pada kebenaran jawaban, tetapi juga mempertimbangkan sisa waktu (*timer*).
4.  **Desain Minimalis Elegan:** Menggunakan *Dark Theme* yang dioptimalkan untuk kenyamanan mata pengguna dalam sesi bermain yang lama.
5.  **State Management Kokoh:** Dibangun menggunakan arsitektur MVVM dan Riverpod untuk mencegah kebocoran memori (*memory leaks*) dan memastikan transisi antar layar yang sangat mulus.

## 🏗️ Cara Kerja Aplikasi

Aplikasi beroperasi dengan alur linier yang sederhana:
1.  **Inisialisasi:** Aplikasi memuat data pengguna lokal (skor sebelumnya) dan mengambil daftar kategori dari server/lokal JSON.
2.  **Seleksi:** Pengguna memilih kategori kuis dari antarmuka *grid*.
3.  **Sesi Kuis (Core Loop):**
    * Controller kuis mengacak (*shuffle*) pertanyaan dari kategori terpilih.
    * Pertanyaan disajikan satu per satu.
    * Input pengguna dikunci (*disabled*) setelah satu opsi ditekan untuk mencegah *spam klik*.
4.  **Rekapitulasi:** Di akhir sesi, skor diakumulasikan dan ditampilkan, lalu disimpan kembali ke *local storage* atau *database*.

## 🛠️ Stack Teknologi

*   **Frontend:** Flutter SDK (Dart)
*   **State Management:** Riverpod
*   **Animasi:** Flutter Animate
*   **UI/UX:** Custom Widgets dengan pendekatan *Flat Minimalist*

## 🚀 Panduan Menjalankan Proyek

1.  Clone repositori ini:
    ```bash
    git clone [https://github.com/username/quiz.git]
    ```
2.  Masuk ke direktori proyek:
    ```bash
    cd quiz
    ```
3. Instal semua dependensi yang dibutuhkan:
    ```bash
    flutter pub get
    ```
4.  Jalankan aplikasi (pastikan emulator atau perangkat sudah terhubung):
    ```bash
    flutter run
    ```
