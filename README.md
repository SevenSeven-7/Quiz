# 🎓 Aplikasi Quiz Interaktif

Aplikasi quiz edukasi berbasis Flutter dengan Python backend API.

## 📋 Struktur Project

```
Quiz/
├── Quiz_App/          # Flutter application
│   ├── lib/           # Source code
│   ├── assets/        # Images, fonts
│   └── pubspec.yaml
│
└── Quiz_Dataset/      # Python API & Database
    ├── database-agamaislam.json
    ├── database-bahasaindonesia.json
    ├── database-matematika.json
    ├── database-ilmupengetahuanalam.json
    ├── database-ilmupengetahuansosial.json
    ├── database-ppkn.json
    ├── database-bahasainggris.json
    ├── api_server.py
    └── requirements.txt
```

## 🚀 Cara Menjalankan

### A. Jalankan di PC (Chrome/Windows)

**1. Start API Server:**
```bash
cd Quiz_Dataset
python api_server.py
```

**2. Update konfigurasi di `Quiz_App/lib/inti/layanan/layanan_api.dart`:**
```dart
static const String baseUrl = 'http://localhost:5000';
```

**3. Start Flutter App:**
```bash
cd Quiz_App
flutter run -d chrome
```

### B. Jalankan di HP Android/iOS

**1. Cek IP Address PC:**
```bash
# Windows
ipconfig

# Atau double-click file:
cek_ip.bat
```

Catat IP address (contoh: `192.168.100.14`)

**2. Update konfigurasi di `Quiz_App/lib/inti/layanan/layanan_api.dart`:**
```dart
static const String baseUrl = 'http://192.168.100.14:5000';
```
**GANTI `192.168.100.14` dengan IP PC Anda!**

**3. Start API Server:**
```bash
cd Quiz_Dataset
python api_server.py
```

**4. Hubungkan HP via USB, aktifkan USB Debugging**

**5. Run di HP:**
```bash
cd Quiz_App
flutter run
```

**📖 Panduan lengkap:** Lihat file `CARA_JALANKAN_DI_HP.md`

### C. Verifikasi

Test API dari browser:
- **Di PC**: http://localhost:5000/health
- **Di HP**: http://192.168.100.14:5000/health (ganti IP)

## 🎯 Fitur Utama

### Sistem Level
- **100 level** per mata pelajaran
- **10 soal acak** per level dari pool 2000 soal
- Level terbuka progresif

### Sistem Penilaian
- **3 Bintang**: Skor ≥90% dan waktu ≤60 detik
- **2 Bintang**: Skor ≥70% dan waktu ≤90 detik
- **1 Bintang**: Skor ≥50%
- **0 Bintang**: Skor <50% (tidak lulus)

### Mata Pelajaran (7 Subjects)
1. **Agama Islam** - 2000 soal
2. **Bahasa Indonesia** - 2000 soal
3. **Matematika** - 2000 soal
4. **IPA** - 2000 soal
5. **IPS** - 2000 soal
6. **PPKn** - 2000 soal
7. **Bahasa Inggris** - 2000 soal

**Total: 14,000 soal**

## 🛠️ Teknologi

### Frontend (Quiz_App)
- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **HTTP Client**: http package
- **Animasi**: Flutter Animate
- **Font**: Google Fonts (Poppins)

### Backend (Quiz_Dataset)
- **Framework**: Flask (Python)
- **Database**: JSON file
- **CORS**: Flask-CORS

## 🔌 Arsitektur

```
Flutter App → HTTP → Python API → Database JSON (7 files)
```

Progress disimpan lokal (SharedPreferences), tidak perlu internet.

## 📊 API Endpoints

- `GET /subjects` - Get semua mata pelajaran
- `GET /questions/{subject_id}` - Get 10 soal acak
- `GET /stats` - Get statistik
- `GET /health` - Health check

## 📝 Format Data Soal

```json
{
  "id": "p1_q1",
  "text": "Berapa jumlah rukun Islam?",
  "type": "mcq",
  "options": ["3", "4", "5", "6"],
  "correctAnswerIndex": 2,
  "correctAnswer": "5"
}
```

## 🎨 Tema

Aplikasi mendukung 3 tema:
- **Light Mode** - Terang dan modern
- **Dark Mode** - Gelap dengan gradient
- **Computer Mode** - Minimalis dan profesional

## 🔧 Development

### Setup Flutter App
```bash
cd Quiz_App
flutter pub get
flutter run
```

### Setup Python API
```bash
cd Quiz_Dataset
pip install -r requirements.txt
python api_server.py
```

### Build Production

#### Android
```bash
cd Quiz_App
flutter build apk --release
```

#### Windows
```bash
cd Quiz_App
flutter build windows --release
```

#### Web
```bash
cd Quiz_App
flutter build web --release
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🐛 Troubleshooting

- **API tidak bisa diakses**: Pastikan Python server berjalan di port 5000
- **Soal tidak muncul**: Cek database JSON ada dan valid
- **Build error**: `flutter clean && flutter pub get`

## 📊 Cara Menambah Soal

Edit file database JSON di `Quiz_Dataset/database-{mapel}.json`, lalu restart API server.

---

## ✅ Status Project

**Database**: 14,000 soal UNIK dalam 7 file JSON terpisah  
**API Server**: Python Flask REST API  
**Flutter App**: No Firebase, menggunakan HTTP API  
**Progress**: Disimpan lokal (SharedPreferences)

Aplikasi menggunakan Python API, bukan Firebase. API server harus berjalan agar aplikasi berfungsi.
