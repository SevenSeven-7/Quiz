# Blueprint Teknis Lengkap - Aplikasi Game "Quiz"

Dokumen ini adalah panduan komprehensif untuk pengembangan, pemeliharaan, dan skalabilitas aplikasi **Quiz**.

## 1. Arsitektur & Pola Desain (MVVM)
Aplikasi menggunakan pola **Model-View-ViewModel** untuk memastikan kode yang bersih dan mudah diuji.
- **Model**: Mendefinisikan struktur data (`User`, `Question`, `Category`).
- **View**: Komponen UI murni yang hanya menampilkan data dari ViewModel.
- **ViewModel (Controller)**: Mengelola logika bisnis, status permainan, dan interaksi data menggunakan **Riverpod**.

## 2. Sistem Desain & Estetika (Premium Dark Mode)
Desain difokuskan pada penggunaan *Whitespace* dan kontras yang lembut untuk mengurangi kelelahan mata.
- **Palet Warna Utama**:
    - Latar: `#121212` (Onyx)
    - Kartu: `#1E1E1E` (Charcoal)
    - Aksen: `#8A2BE2` (Electric Violet)
- **Animasi**: Menggunakan `flutter_animate` untuk:
    - *Staggered Entry*: Elemen muncul satu per satu.
    - *Shake Error*: Getaran pada tombol saat jawaban salah.
    - *Score Count*: Angka yang terus bertambah di layar hasil.

## 3. Skema Data (Database Blueprint)
### Local Persistence (Hive/SharedPrefs)
- `last_score`: Skor terakhir yang dicapai.
- `high_score`: Skor tertinggi sepanjang masa per kategori.
- `user_name`: Nama profil pengguna.

### Remote Schema (Firestore - Next Phase)
- **Collection: `questions`**
  - `id` (String)
  - `category_id` (String)
  - `text` (String)
  - `options` (Array of Strings)
  - `correct_index` (Integer)
- **Collection: `leaderboard`**
  - `uid` (String)
  - `username` (String)
  - `score` (Integer)
  - `timestamp` (Timestamp)

## 4. Alur Kerja Inti (The Gameplay Loop)
1.  **Splash**: Inisialisasi Firebase & Load High Score lokal.
2.  **Home**: Menampilkan daftar kategori. Kategori di-*fetch* dari servis data.
3.  **Quiz Sesi**:
    - 10 Soal acak per sesi.
    - Timer 15 detik per soal.
    - Lock input setelah jawaban terpilih.
4.  **Result**: Kalkulasi skor akhir + Update High Score jika terlampaui.

## 5. Optimasi Performa
- **Image Caching**: Menggunakan `cached_network_image` untuk ikon kategori.
- **Lazy Loading**: Grid kategori hanya merender apa yang terlihat di layar.
- **State Selection**: Hanya bagian widget yang berubah yang akan di-*rebuild* (Optimasi Riverpod).

## 6. Dokumentasi Teknis (README.md)
Lihat [README.md](file:///c:/laragon/www/Quiz/README.md) untuk instruksi instalasi dan menjalankan aplikasi.
