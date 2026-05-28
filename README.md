# 🎓 Aplikasi Quiz Edukasi Interaktif Premium

Aplikasi kuis edukatif mutakhir yang dibangun dengan **Flutter**. Dirancang khusus untuk memberikan pengalaman belajar yang mulus, stabil, dan premium. Aplikasi ini berjalan **100% offline** (tanpa koneksi internet atau server pihak ketiga) dengan menggunakan sistem basis data tersemat (*embedded JSON*). Dapat dijalankan secara responsif di Android, iOS, Windows, Mac, Linux, maupun Web.

## ✨ Fitur Utama (Core Features)

1. **📚 Basis Data Offline Ekstensif (3.500 Soal)**
   - Memuat total **3.500 pertanyaan unik** yang diproses secara lokal tanpa hambatan (*zero latency*) menggunakan `rootBundle.loadString()`.
   - Terbagi ke dalam **7 mata pelajaran utama** (Masing-masing berisi persis **500 soal**): *Agama Islam, Bahasa Indonesia, Matematika, IPA, IPS, PPKn, Bahasa Inggris*.

2. **✨ Animasi & Transisi Premium (60 FPS Locked)**
   - **Custom Page Route Transitions:** Setiap perpindahan layar menggunakan efek kombinasi transisi pudar (*Fade*), skala (*Scale*), dan geser (*Slide*).
   - **ValueKey Caching:** Transisi soal dioptimalkan dengan efek masuk berurutan (*Staggered Entrance*) yang mulus tanpa menguras memori CPU.
   - **Hardware Acceleration:** Animasi bercahaya tingkat lanjut (*Glowing/Sparks*) pada profil dan gelar dibungkus menggunakan *RepaintBoundary* untuk mencegah kebocoran memori.

3. **🎵 Sistem Audio Kolam (Audio Pool)**
   - Desain arsitektur suara layaknya *engine game*. Menggunakan multi-lapis (*3 layers*) `AudioPlayer` yang bekerja secara *Round-Robin*.
   - Mencegah suara patah-patah (*stuttering*) ketika mengetuk pilihan dengan kecepatan tinggi.

4. **🌙 Tema Responsif Adaptif**
   - Mendukung **Mode Terang** dan **Mode Gelap**. Beradaptasi otomatis mengenali orientasi dan jenis perangkat (HP vs Komputer).

---

## ⚙️ Mekanisme & Logika Kuis (Game Logic)

Aplikasi ini menggunakan sistem logika pencapaian yang ketat dan tersimpan secara permanen (*SharedPreferences*) yang dikelola melalui `Riverpod`.

### 1. Struktur Level & Soal
Setiap mata pelajaran (Kategori) memiliki **100 Level**. Setiap Level terdiri dari **5 Pertanyaan** (Kombinasi Pilihan Ganda & Uraian/Esai). Pemain harus menjawab kelima soal tersebut secara berurutan.

### 2. Logika Penghitungan Bintang (Star Rating)
Setelah ke-5 pertanyaan dijawab, sistem mengkalkulasi pencapaian Bintang berdasarkan kombinasi **Jumlah Jawaban Benar (Skor)** dan **Kecepatan Waktu Menjawab**, dengan parameter absolut berikut:

- ⭐️⭐️⭐️ **3 Bintang Sempurna:** Skor penuh (5 Benar) **DAN** diselesaikan dalam waktu `≤ 80 Detik`.
- ⭐️⭐️ **2 Bintang Hebat:** Skor (3 - 4 Benar) **DAN** diselesaikan dalam waktu `≤ 120 Detik`.
- ⭐️ **1 Bintang Cukup:** Skor (1 - 2 Benar) **DAN** diselesaikan dalam waktu `≤ 140 Detik`.
- ❌ **0 Bintang (Gagal):** Skor 0 (Salah semua) **ATAU** waktu pengerjaan `> 140 Detik` (Meskipun ada yang benar). Level ini harus diulang.

*Catatan: Sistem menyimpan pencapaian bintang tertinggi. Mengulang level tidak akan menurunkan riwayat bintang terbaik Anda.*

### 3. Logika Kenaikan Gelar (Title Progression)
Total seluruh bintang yang dikumpulkan dari 700 level (Batas Maksimal = **2.100 Bintang**) diakumulasikan menjadi parameter **Gelar Pemain**. Tingkatannya adalah:

- 🟤 **Pemula:** 0 - 299 Bintang
- 🟠 **Perunggu:** 300 - 599 Bintang
- ⚪ **Perak:** 600 - 899 Bintang
- 🟡 **Emas:** 900 - 1199 Bintang
- 🔘 **Platinum:** 1200 - 1499 Bintang
- 💎 **Berlian:** 1500 - 1799 Bintang
- 👑 **Legenda:** 1800 - 2100 Bintang *(Gelar tertinggi, memicu batas animasi menyala dengan partikel cipratan bintang pada foto profil)*.

---

## 📋 Struktur Project

```text
Quiz/
└── Quiz_App/          # Aplikasi Utama Flutter
    ├── lib/           # Source code (arsitektur berbasis fitur)
    │   ├── fitur/     # Modul layar (beranda, splash, kuis, hasil, dll)
    │   ├── inti/      # Utilitas inti (konstanta warna, layanan, helper)
    │   └── model/     # Struktur data model
    ├── assets/        # Media (Gambar, Suara, Font, Lottie)
    │   └── datasets/  # Database JSON lokal
    └── pubspec.yaml   # Konfigurasi dependensi dan deklarasi asset
```

## 🚀 Cara Menjalankan

Karena murni offline, Anda tidak membutuhkan API atau backend tambahan:

1. Pastikan SDK Flutter terpasang.
2. Buka terminal dan arahkan ke direktori utama proyek:
```bash
flutter clean
flutter pub get
flutter run
```

3. **Build Rilis ke APK (Android Production):**
```bash
flutter build apk --release
```
File APK akan di-*generate* di direktori: `build/app/outputs/flutter-apk/app-release.apk`
