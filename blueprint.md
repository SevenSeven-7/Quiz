# Blueprint Pengembangan Aplikasi Quiz (Versi Rilis 2.0) 🚀

Aplikasi **Quiz** adalah platform asah otak edukatif berbasis tingkat/level yang dirancang secara premium untuk mendukung pembelajaran asinkron. Menampilkan 200 Level kuis real (100 Level Bahasa Indonesia + 100 Level Matematika) dengan alur yang responsif, dinamis, dan terhubung penuh ke cloud Firestore.

---

## 1. Identitas & Tema Visual Premium
*   **Nama Aplikasi**: Quiz
*   **Tema UI/UX**: *HSL Glowing Dark Mode* (Deep Onyx Black, Electric Violet, Emerald Green, Gold, dan Crimson Red).
*   **Adaptabilitas Perangkat**: Responsif penuh terhadap orientasi layar dan lebar peranti (Mobile Android/iOS, Tablet/iPad, dan Desktop).
*   **Pendaran Dinamis**: Warna aksen avatar, batas kartu, dan badge lencana berubah secara reaktif mengikuti perolehan bintang kuis pemain.

---

## 2. Arsitektur Kode & Teknologi
*   **SDK Utama**: Flutter (Dart)
*   **Pola Desain (Design Pattern)**: MVVM (Model-View-ViewModel).
*   **Manajemen Status (State Management)**: Riverpod (Notifier & Family Provider).
*   **Penyimpanan Cloud**: Firebase Firestore (Pengambilan kategori, tingkat level, dan soal kuis secara asinkron).
*   **Penyimpanan Lokal Permanen**: 
    *   `shared_preferences` (Menyimpan nama pemain secara luring).
    *   *Local JSON Backup* (`assets/data/questions.json` sebagai fallback supercepat jika perangkat luring).
*   **Paket Animasi**: `flutter_animate` (Menyediakan micro-animation premium pada ikon, tombol, dan transisi layar).

---

## 3. Alur Pengguna (User Flow) & Navigasi Responsif

### A. Alur Awal Masuk
1.  **Native Launch Screen (Android)**: Memuat dengan latar belakang solid hitam (`@android:color/black`) untuk menghilangkan kilatan putih yang mengganggu.
2.  **Layar Splash Animasi**: Animasi logo "Q" bersinar dan teks "QUIZ" memudar masuk (2 detik).
3.  **Deteksi Nama Pemain (SharedPreferences)**:
    *   Jika **belum ada nama**: Diarahkan ke layar **Buat Nama Pemain** dengan input form ter-validasi (3-15 karakter).
    *   Jika **sudah ada nama**: Langsung diarahkan ke **Layar Navigasi Utama**.

### B. Pusat Navigasi Responsif (Multi-Perangkat)
Sistem navigasi mendeteksi lebar viewport secara waktu-nyata (`MediaQuery.of(context).size.width`):
*   **Lebar Layar <= 600px (Ponsel Android/iOS)**: Menyajikan `BottomNavigationBar` dengan batas atas neon violet yang dibungkus `SafeArea` guna mencegah pemotongan tombol oleh notch bawah/home indicator iOS.
*   **Lebar Layar > 600px (Tablet/PC/Laptop)**: Menyajikan `NavigationRail` vertikal yang sangat elegan di sisi kiri layar.

---

## 4. Rincian Fitur Utama & Logika Permainan

### A. Tab Beranda (HomeScreen)
*   **Salam Pembuka Personal**: Sapaan reaktif seperti *"Halo, [Nama Pemain]"*.
*   **Kartu Tingkat Kecerdasan**: Papan informasi dinamis bersimbol otak bersinar (`Icons.psychology`) yang mengalkulasi akumulasi bintang menjadi lencana kehormatan.
*   **Daftar Kategori**: Pilihan kategori Bahasa Indonesia (Part 1) dan Matematika (Part 2).

### B. Tab Profil (ProfileScreen)
*   **Avatar Inisial Glowing**: Lingkaran inisial nama pemain dengan pancaran pendaran (*glowing shadow*) yang warnanya mencerminkan kualifikasi tingkat kecerdasan saat ini.
*   **Lencana Militer Kehormatan**: Badge bersimbol `Icons.military_tech` dengan gradasi warna premium sesuai gelar.
*   **Statistik Kecerdasan Terpisah**: Kartu rekapitulasi data kuis:
    *   🇮🇩 Bahasa Indonesia: `X / 100 Level` diselesaikan.
    *   ➕ Matematika: `X / 100 Level` diselesaikan.
    *   ⭐ Total Bintang Terkumpul.
*   **Ubah Nama Pemain**: Dialog input terintegrasi untuk mengganti nama pemain secara instan dan reaktif di seluruh aplikasi.

### C. Pemilihan Tingkat (Level Selection Screen)
*   **Grid Responsif**: Jumlah kolom dihitung secara dinamis (5 kolom untuk mobile, 8 kolom untuk tablet, dan 10-12 kolom untuk PC/Laptop) untuk menghindari tampilan tombol kuis yang melar.
*   **Rating Bintang**: Setiap level menampilkan pencapaian 1 hingga 3 bintang.
*   **Logika Kunci Level**: Level `n+1` hanya akan terbuka jika level `n` minimal telah diselesaikan dengan 1 bintang.

### D. Lembar Pengerjaan Kuis (Quiz Screen)
Setiap tingkat kuis terdiri dari **10 pertanyaan**:
*   **Soal Pilihan Ganda (MCQ)**: 8 Soal dengan opsi A, B, C, D yang diacak. Evaluasi warna instan (hijau untuk benar, merah + getar untuk salah) dengan jeda otomatis 2 detik sebelum beralih.
*   **Soal Uraian (Essay)**: 2 Soal (berada pada nomor 5 dan nomor 10) dengan input pengetikan teks mandiri yang tidak peka terhadap huruf kapital (*case-insensitive*) dan memangkas spasi berlebih (*trim space*).
*   **Perhitungan Bintang Kelulusan**:
    *   ⭐ Bintang 3: Skor kelulusan kuis $\ge 90\%$ dan waktu pengerjaan $\le 60$ detik.
    *   ⭐ Bintang 2: Skor kelulusan kuis $\ge 70\%$ dan waktu pengerjaan $\le 90$ detik.
    *   ⭐ Bintang 1: Skor kelulusan kuis $\ge 50\%$.
    *   💀 Bintang 0 (Gagal): Skor di bawah $50\%$.

---

## 5. Matriks Tingkat Kecerdasan (Gelar Penghargaan)

Gelar kecerdasan dihitung dari akumulasi perolehan bintang dari total 200 Level kuis:

| Akumulasi Bintang | Gelar Penghargaan | Simbol & Warna Tema Profil | Kode Warna (Hex) |
| :--- | :--- | :--- | :--- |
| **0 - 15 Bintang** | Calon Juara | 🎖️ Abu-abu Perak | `#95A5A6` |
| **16 - 60 Bintang** | Pencari Ilmu | 📘 Biru Muda Cerah | `#3498DB` |
| **61 - 150 Bintang** | Pelajar Tangguh | 💚 Hijau Emerald | `#2ECC71` |
| **151 - 300 Bintang** | Pikir Cepat | 💜 Ungu Violet | `#9B59B6` |
| **301 - 450 Bintang** | Cerdas Cermat | 🧡 Oranye Tembaga | `#E67E22` |
| **451 - 570 Bintang** | Master Kuis | 💛 Kuning Emas | `#F1C40F` |
| **571 - 600 Bintang** | Genius Sejati | ❤️ Merah Membara | `#E74C3C` |

---

## 6. Struktur Data Database (Firebase Firestore)
*   **Collection: `parts`**
    *   `title` (Teks judul bagian)
    *   `description` (Teks deskripsi kuis)
    *   `isLocked` (Boolean)
*   **Collection: `levels`**
    *   `partId` (ID tautan bagian kuis)
    *   `order` (Nomor urut level)
    *   `questions` (Array Objek Soal: `id`, `text`, `type`, `options`, `correctAnswerIndex`, `correctAnswer`)
