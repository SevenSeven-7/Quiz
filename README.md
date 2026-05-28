# 🎓 Aplikasi Quiz Interaktif

Aplikasi quiz edukasi interaktif yang dibangun menggunakan **Flutter**. Aplikasi ini berjalan 100% offline dengan data tersemat (embedded) di dalam aplikasi, tanpa bergantung pada koneksi internet atau server pihak ketiga. Aplikasi dapat berjalan dengan mulus di berbagai platform seperti Android, iOS, Windows, Mac, Linux, maupun Web.

## 📋 Struktur Project

```text
Quiz/
└── Quiz_App/          # Flutter application
    ├── lib/           # Source code utama
    ├── assets/        # Images, fonts, Lottie animations
    │   └── datasets/  # Database JSON untuk semua soal
    └── pubspec.yaml   # Konfigurasi dependensi dan deklarasi asset
```

## 📦 Database Soal

Aplikasi ini memuat **7.000 pertanyaan** yang dikelompokkan menjadi 7 mata pelajaran dasar (1.000 soal unik per mata pelajaran):
1. **Agama Islam**: Rukun iman, ibadah, kisah nabi, dll.
2. **Bahasa Indonesia**: Kosakata, tata bahasa, ejaan baku, dll.
3. **Matematika**: Aritmatika, aljabar, dsb.
4. **Ilmu Pengetahuan Alam (IPA)**: Fisika, biologi, ilmu tata surya.
5. **Ilmu Pengetahuan Sosial (IPS)**: Sejarah, geografi provinsi & negara.
6. **PPKn**: UUD 1945, Pancasila, sistem pemerintahan.
7. **Bahasa Inggris**: Vocabulary, grammar, pemahaman dasar.

*Tidak ada redundansi. Semua soal dan dataset ditangani secara lokal menggunakan `rootBundle.loadString()` tanpa latency.*

## 🚀 Cara Menjalankan

Karena tidak ada server backend atau API terpisah, Anda cukup merujuk pada standar penggunaan Flutter.

**1. Persiapan:**
Pastikan SDK Flutter terinstall di perangkat Anda. Jika belum, baca panduan [Instalasi Flutter](https://docs.flutter.dev/get-started/install).

**2. Jalankan Aplikasi:**
Buka terminal dan arahkan ke direktori project Flutter:
```bash
cd Quiz_App
flutter pub get
flutter run
```

**3. Build APK (untuk Android):**
Untuk mendistribusikan aplikasi ke Android secara mandiri (production):
```bash
flutter build apk --release
```
File APK rilis akan otomatis digenerate dan dapat ditemukan pada direktori: `Quiz_App/build/app/outputs/flutter-apk/app-release.apk`
