# Quiz - Aplikasi Kuis Edukatif Premium & Multi-Perangkat 🧠

**Quiz** adalah aplikasi kuis edukatif lintas-platform berbasis tingkat/level yang dirancang secara premium menggunakan Flutter. Aplikasi ini berfokus pada kenyamanan mata (*Deep HSL Dark Mode*), kegunaan yang reaktif (*Riverpod State Management*), kegesitan animasi (*Flutter Animate*), dan sinkronisasi awan (*Firebase Firestore*) dengan kemampuan luring penuh (*Local JSON Fallback*).

Menantang pemain melewati **200 Tingkat Level** (100 Level Bahasa Indonesia & 100 Level Matematika) dengan total **2.000 Soal Real** yang dirancang secara edukatif.

---

## 📋 Fitur Utama Aplikasi

1.  **Pendaftaran Nama Pemain Luring (`shared_preferences`)**:
    *   Mencatat nama pemain secara permanen pada perangkat lokal untuk melacak kemajuan bermain tanpa memerlukan akun berbayar yang rumit.
2.  **Pusat Navigasi Responsif Lintas-Perangkat**:
    *   **Ponsel (Width $\le$ 600px)**: Menyajikan `BottomNavigationBar` bersinar violet dengan proteksi area aman (`SafeArea`).
    *   **Tablet/PC (Width $>$ 600px)**: Menyajikan `NavigationRail` di sisi kiri layar dengan pembatas neon violet yang memukau.
3.  **Matriks Gelar Kecerdasan (Bintang Game)**:
    *   Mengakumulasi perolehan bintang (1-3 ⭐ per level kuis) menjadi gelar kehormatan militer dan warna aksen avatar dinamis yang bersinar di menu Profil.
4.  **Tab Profil Premium**:
    *   Menyajikan avatar inisial nama pemain yang bersinar (*glowing*), lencana gelar, rekapitulasi data level yang berhasil dipecahkan per kategori secara akurat, serta opsi instan ubah nama.
5.  **Lembar Pengerjaan Kuis Interaktif**:
    *   Menyajikan **8 Soal Pilihan Ganda (MCQ)** yang diacak dengan evaluasi warna instan (hijau/merah) + getaran getar jika salah, serta **2 Soal Uraian (Essay)** dengan pemangkas spasi otomatis dan deteksi *case-insensitive*.
6.  **Penyuntingan & Sinkronisasi Firestore Mandiri**:
    *   Firebase Firestore terintegrasi penuh untuk sinkronisasi soal. Jika perangkat luring, data akan langsung dimuat secara otomatis dari fallback `assets/data/questions.json`.

---

## 🛠️ Stack Teknologi

*   **Platform Utama**: Flutter SDK (Dart)
*   **Arsitektur Kode**: MVVM (Model-View-ViewModel)
*   **Manajemen Status**: Riverpod (`StateNotifierProvider` & Family)
*   **Basis Data Online**: Firebase Firestore Core
*   **Penyimpanan Luring**: SharedPreferences + `rootBundle` JSON
*   **Animasi Efek**: `flutter_animate` (Fade-in, scale, slide, shake)
*   **Gaya Desain**: *Modern Glassmorphic Slate Dark Theme*

---

## 🚀 Langkah Menjalankan Proyek

1.  **Clone Repositori**:
    ```bash
    git clone https://github.com/SevenSeven-7/Quiz.git
    cd Quiz
    ```
2.  **Instalasi Dependensi**:
    ```bash
    flutter pub get
    ```
3.  **Konfigurasi Firebase**:
    *   Aplikasi dikonfigurasi menggunakan opsi platform otomatis via **`firebase_options.dart`**.
4.  **Menjalankan Aplikasi**:
    *   Pastikan emulator atau HP Android/iOS Anda sudah terhubung secara aktif:
    ```bash
    flutter run
    ```
