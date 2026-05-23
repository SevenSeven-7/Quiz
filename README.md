# Quiz — Aplikasi Kuis Edukatif Premium & Multi-Perangkat 🧠

**Quiz** adalah aplikasi kuis edukatif lintas-platform berbasis tingkat/level yang dirancang secara premium menggunakan Flutter. Aplikasi ini berfokus pada kenyamanan mata (*Deep HSL Dark Mode*), kegunaan yang reaktif (*Riverpod State Management*), kegesitan animasi (*Flutter Animate*), dan sinkronisasi awan (*Firebase Firestore*) dengan kemampuan luring penuh (*Local JSON Fallback*).

Menantang pemain melewati **700 Level** (100 Level × 7 Mata Pelajaran) dengan total **7.000 Soal Real** yang dirancang secara edukatif — dengan sistem pengacakan dinamis sehingga setiap sesi selalu terasa berbeda.

---

## 📋 Fitur Utama Aplikasi

1.  **Pendaftaran Nama Pemain Luring (`shared_preferences`)**:
    *   Mencatat nama pemain secara permanen pada perangkat lokal untuk melacak kemajuan bermain tanpa memerlukan akun berbayar yang rumit.
2.  **Pusat Navigasi Responsif Lintas-Perangkat**:
    *   **Ponsel (Width ≤ 600px)**: Menyajikan `BottomNavigationBar` bersinar violet dengan proteksi area aman (`SafeArea`).
    *   **Tablet/PC (Width > 600px)**: Menyajikan `NavigationRail` di sisi kiri layar dengan pembatas neon violet yang memukau.
3.  **Tiga Mode Tema**:
    *   ☀️ **Mode Terang** — Biru muda cerah, cocok penggunaan siang hari
    *   🌙 **Mode Gelap** — Biru gelap neon futuristik, ideal malam hari
    *   💻 **Mode Komputer** — Abu putih minimalis profesional, terbaik untuk desktop
4.  **Matriks Gelar Kecerdasan (Bintang Game)**:
    *   Mengakumulasi perolehan bintang (1-3 ⭐ per level kuis) menjadi gelar kehormatan militer dan warna aksen avatar dinamis yang bersinar di menu Profil.
5.  **Tab Profil Premium**:
    *   Menyajikan avatar inisial nama pemain yang bersinar (*glowing*), lencana gelar, rekapitulasi data level yang berhasil dipecahkan per kategori secara akurat, serta opsi instan ubah nama.
6.  **Lembar Pengerjaan Kuis Interaktif**:
    *   Menyajikan **8 Soal Pilihan Ganda (MCQ)** yang diacak dengan evaluasi warna instan (hijau/merah) + getaran getar jika salah, serta **2 Soal Uraian (Essay)** dengan pemangkas spasi otomatis dan deteksi *case-insensitive*.
    *   Setiap soal **diacak secara dinamis** (urutan opsi A/B/C/D selalu berbeda setiap sesi).
7.  **Penyuntingan & Sinkronisasi Firestore Mandiri**:
    *   Firebase Firestore terintegrasi penuh untuk sinkronisasi soal. Jika perangkat luring, data akan langsung dimuat secara otomatis dari fallback `assets/data/questions.json`.

---

## 🏫 Mata Pelajaran Quiz

| No | Mata Pelajaran | Total Level | Total Soal |
|:--:|:---|:---:|:---:|
| 1 | 🕌 Agama Islam | 100 Level | 1.000 Soal |
| 2 | 🇮🇩 Bahasa Indonesia | 100 Level | 1.000 Soal |
| 3 | ➕ Matematika | 100 Level | 1.000 Soal |
| 4 | 🔬 IPA (Ilmu Pengetahuan Alam) | 100 Level | 1.000 Soal |
| 5 | 🌏 IPS (Ilmu Pengetahuan Sosial) | 100 Level | 1.000 Soal |
| 6 | ⚖️ PPKn (Pendidikan Pancasila) | 100 Level | 1.000 Soal |
| 7 | 🗣️ Bahasa Inggris | 100 Level | 1.000 Soal |
| **Total** | | **700 Level** | **7.000 Soal** |

---

## 🛠️ Stack Teknologi

*   **Platform Utama**: Flutter SDK (Dart)
*   **Arsitektur Kode**: MVVM (Model-View-ViewModel)
*   **Manajemen Status**: Riverpod (`StateNotifierProvider` & Family)
*   **Basis Data Online**: Firebase Firestore Core
*   **Penyimpanan Luring**: SharedPreferences + `rootBundle` JSON
*   **Animasi Efek**: `flutter_animate` (Fade-in, scale, slide, shake)
*   **Gaya Desain**: *HSL Glowing Multi-Mode Theme System*

---

## 🏗️ Arsitektur Kode & Struktur Direktori

```
lib/
├── firebase_options.dart         # Konfigurasi Firebase otomatis
├── main.dart                     # Entry point + QuizApp widget
├── model/
│   └── model.dart                # Data models (PartModel, LevelModel, QuestionModel)
├── inti/
│   ├── konstanta/
│   │   └── warna_aplikasi.dart   # Palet warna ketiga tema
│   ├── layanan/
│   │   ├── layanan_data.dart     # Service untuk Local JSON
│   │   └── layanan_firebase.dart # Service Firebase Firestore
│   ├── penyedia/
│   │   └── penyedia_tema.dart    # Riverpod provider untuk tema
│   └── tema/
│       ├── tema_aplikasi.dart    # Facade/Orchestrator tema
│       ├── mode_terang.dart      # ☀️ Light Mode config
│       ├── mode_gelap.dart       # 🌙 Dark Mode config
│       └── mode_komputer.dart    # 💻 Computer Mode config
└── fitur/
    ├── splash/
    │   ├── layar_splash.dart     # Splash screen animasi
    │   └── layar_buat_nama.dart  # Layar input nama pemain baru
    ├── beranda/
    │   ├── layar_beranda.dart    # Tab beranda (daftar kategori)
    │   ├── layar_pilih_level.dart# Grid pemilihan level
    │   └── layar_utama.dart      # Navigasi utama (Bottom Nav / Rail)
    ├── kuis/                     # Layar pengerjaan soal kuis
    ├── hasil/                    # Layar hasil kuis & bintang
    ├── pengaturan/               # Tab pengaturan tema
    └── progres/                  # Provider progres & bintang
```

---

## 🎨 Sistem Tema (Tiga Mode)

Tema dikelola menggunakan **Facade Pattern** — setiap mode tema dipisah ke file sendiri untuk *maintainability* dan isolasi bug.

### Struktur File Tema

```
lib/inti/tema/
├── tema_aplikasi.dart    # Facade (pintu gerbang tema)
├── mode_terang.dart      # ☀️ Light Mode
├── mode_gelap.dart       # 🌙 Dark Mode
└── mode_komputer.dart    # 💻 Computer Mode
```

### Spesifikasi Masing-Masing Mode

#### ☀️ Mode Terang
| Komponen | Nilai |
|:---|:---|
| **Font** | Google Fonts Outfit |
| **Background** | `#E8F4FF` (Biru muda terang) |
| **Primary** | `#1E90FF` (Biru cerah) |
| **Surface** | `#FFFFFF` (Putih) |
| **Border Radius** | 16–20px (Rounded) |
| **Cocok Untuk** | Penggunaan siang hari |

#### 🌙 Mode Gelap
| Komponen | Nilai |
|:---|:---|
| **Font** | Google Fonts Outfit |
| **Background** | `#020B1A` (Biru gelap malam) |
| **Primary** | `#1E90FF` (Biru neon) |
| **Surface** | `#071428` (Biru tua) |
| **Border Radius** | 16–20px (Rounded) |
| **Cocok Untuk** | Penggunaan malam hari |

#### 💻 Mode Komputer
| Komponen | Nilai |
|:---|:---|
| **Font** | Google Fonts Inter (Profesional) |
| **Background** | `#F0F0F0` (Abu terang) |
| **Primary** | `#333333` (Abu gelap) |
| **Surface** | `#FFFFFF` + border `#CCCCCC` |
| **Border Radius** | 12–16px (Lebih kotak) |
| **Cocok Untuk** | Desktop / tampilan formal |

### Cara Mengganti Tema (Riverpod)

```dart
// Di widget — membaca tema aktif
final appTheme = ref.watch(temaProvider);

// Mengubah tema
ref.read(temaProvider.notifier).ubahTema(AppThemeMode.dark);
ref.read(temaProvider.notifier).ubahTema(AppThemeMode.light);
ref.read(temaProvider.notifier).ubahTema(AppThemeMode.computer);
```

### Perbandingan Sebelum & Sesudah Refactoring

| Aspek | Sebelum | Sesudah |
|:---|:---|:---|
| **File Tema** | 1 file (200+ baris) | 4 file (~70 baris each) |
| **Maintainability** | Sulit, semua tercampur | Mudah, terpisah per tema |
| **Bug Risk** | Tinggi (konflik antar tema) | Rendah (isolasi penuh) |
| **Scalability** | Sulit tambah tema | Mudah, tinggal buat file |
| **Code Clarity** | Rendah | Tinggi |

---

## 🔄 Alur Pengguna (User Flow)

### A. Alur Awal Masuk
1.  **Native Launch Screen (Android)**: Memuat dengan latar belakang solid hitam untuk menghilangkan kilatan putih.
2.  **Layar Splash Animasi**: Animasi logo bersinar dan teks "Quiz" memudar masuk (2.8 detik) — adaptif 3 tema.
3.  **Deteksi Nama Pemain (SharedPreferences)**:
    *   Jika **belum ada nama**: Diarahkan ke layar **Buat Nama Pemain** dengan animasi partikel dan form ter-validasi (3–15 karakter).
    *   Jika **sudah ada nama**: Langsung diarahkan ke **Layar Navigasi Utama**.

### B. Pusat Navigasi Responsif (Multi-Perangkat)
Sistem navigasi mendeteksi lebar viewport secara waktu-nyata (`MediaQuery.of(context).size.width`):
*   **Lebar Layar ≤ 600px (Ponsel)**: `BottomNavigationBar` dengan batas atas neon violet + `SafeArea`.
*   **Lebar Layar > 600px (Tablet/PC)**: `NavigationRail` vertikal elegan di sisi kiri layar.

### C. Pemilihan Tingkat (Level Selection)
*   **Grid Responsif**: 5 kolom (mobile) → 8 kolom (tablet) → 10-12 kolom (PC).
*   **Rating Bintang**: Setiap level menampilkan pencapaian 1–3 bintang.
*   **Semua Level Terbuka**: Pemain bebas memilih level mana pun tanpa harus menyelesaikan level sebelumnya.

### D. Lembar Pengerjaan Kuis
Setiap tingkat kuis terdiri dari **10 pertanyaan**:
*   **Soal MCQ (8 soal)**: Opsi A/B/C/D yang diacak setiap sesi. Evaluasi warna instan (hijau = benar, merah + getar = salah). Jeda 2 detik otomatis sebelum beralih soal.
*   **Soal Essay (2 soal)**: Nomor 5 & 10, input teks bebas, *case-insensitive*, *trim space* otomatis.
*   **Perhitungan Bintang**:
    *   ⭐⭐⭐ Bintang 3: Skor ≥ 90% & waktu ≤ 60 detik
    *   ⭐⭐ Bintang 2: Skor ≥ 70% & waktu ≤ 90 detik
    *   ⭐ Bintang 1: Skor ≥ 50%
    *   💀 Bintang 0 (Gagal): Skor < 50%

---

## 🏅 Matriks Tingkat Kecerdasan (Gelar Penghargaan)

Gelar dihitung dari akumulasi bintang seluruh 700 level kuis:

| Akumulasi Bintang | Gelar Penghargaan | Warna Aksen | Kode Hex |
|:---|:---|:---|:---|
| **0 – 105** | Calon Juara | 🎖️ Abu-abu Perak | `#95A5A6` |
| **106 – 420** | Pencari Ilmu | 📘 Biru Muda Cerah | `#3498DB` |
| **421 – 1050** | Pelajar Tangguh | 💚 Hijau Emerald | `#2ECC71` |
| **1051 – 2100** | Pikir Cepat | 💜 Ungu Violet | `#9B59B6` |
| **2101 – 3150** | Cerdas Cermat | 🧡 Oranye Tembaga | `#E67E22` |
| **3151 – 3990** | Master Kuis | 💛 Kuning Emas | `#F1C40F` |
| **3991 – 4200** | Genius Sejati | ❤️ Merah Membara | `#E74C3C` |

---

## 🗄️ Struktur Data Firebase Firestore

```
Firestore Root
├── parts/                    # Collection bagian/kategori
│   ├── p_agama/              # Document Agama Islam
│   │   ├── title: "Quiz Agama Islam"
│   │   ├── description: "..."
│   │   └── isLocked: false
│   ├── p1/                   # Bahasa Indonesia
│   ├── p2/                   # Matematika
│   └── ...
│
└── levels/                   # Collection level kuis
    ├── p1_l1/                # Document Level 1 Bahasa Indonesia
    │   ├── partId: "p1"
    │   ├── order: 1
    │   └── questions: [Array of 10 question objects]
    └── ...

# Struktur satu soal MCQ:
{
  "id": "p1_l1_q1",
  "type": "mcq",
  "text": "Pertanyaan soal...",
  "options": ["A", "B", "C", "D"],   # Diacak saat runtime
  "correctAnswerIndex": 2             # Index jawaban benar
}

# Struktur satu soal Essay:
{
  "id": "p1_l1_q5",
  "type": "essay",
  "text": "Pertanyaan essay...",
  "correctAnswer": "jawaban"          # Case-insensitive, trim space
}
```

---

## 🚀 Langkah Menjalankan Proyek

### 1. Clone Repositori
```bash
git clone https://github.com/SevenSeven-7/Quiz.git
cd Quiz
```

### 2. Instalasi Dependensi
```bash
flutter pub get
```

### 3. Konfigurasi Firebase
Aplikasi dikonfigurasi menggunakan opsi platform otomatis via **`firebase_options.dart`** yang sudah tersedia di repositori.

### 4. Menjalankan Aplikasi
Pastikan emulator atau HP Android/iOS sudah terhubung:
```bash
flutter run
```

### 5. Regenerasi Soal (Opsional)
Jika ingin meregenerasi soal lokal:
```bash
cd scripts
python generate_questions.py
```

Untuk upload soal ke Firebase Firestore:
```bash
npm install firebase-admin
node upload_to_firebase.js
```

---

## 🔧 Cara Menambah Tema Baru

1. Buat file baru: `lib/inti/tema/mode_baru.dart`
2. Copy struktur dari salah satu mode yang ada
3. Sesuaikan warna dan konfigurasi
4. Tambahkan di `tema_aplikasi.dart`:
   ```dart
   static ThemeData get newTheme => ModeBaru.tema;
   ```
5. Tambahkan enum di `penyedia_tema.dart`:
   ```dart
   enum AppThemeMode { dark, light, computer, baru }
   ```

---

## ✅ Checklist Implementasi & Status

### Sistem Tema
- [x] Buat `mode_terang.dart` — Light Mode
- [x] Buat `mode_gelap.dart` — Dark Mode
- [x] Buat `mode_komputer.dart` — Computer Mode
- [x] Refactor `tema_aplikasi.dart` jadi Facade
- [x] Tema persisten via SharedPreferences
- [x] Splash screen adaptif 3 tema
- [x] Layar buat nama adaptif 3 tema

### Konten Quiz
- [x] 7 Mata Pelajaran: Agama Islam, B.Indonesia, Matematika, IPA, IPS, PPKn, B.Inggris
- [x] 700 Level total (100 per mapel)
- [x] 7.000 Soal (1.000 per mapel, MCQ + Essay)
- [x] Sistem pengacakan opsi soal dinamis
- [x] Upload ke Firebase Firestore

### Fitur Teknis
- [x] MVVM + Riverpod State Management
- [x] Firebase Firestore + Local JSON Fallback
- [x] Navigasi responsif (BottomNav / NavigationRail)
- [x] Grid level responsif (5/8/10-12 kolom)
- [x] Animasi `flutter_animate` di seluruh layar
- [x] `flutter analyze` — No issues found ✅

---

## 📝 Catatan Penting untuk Developer

1. **Splash Screen**: Menggunakan `SharedPreferences` untuk routing — jika nama belum ada → `LayarBuatNama`, jika sudah ada → `MainNavigationScreen`.
2. **Pengacakan Soal**: Pengacakan dilakukan di level UI (saat soal dimuat ke layar kuis), bukan di database — sehingga jawaban tetap valid meski urutan opsi berubah.
3. **Firebase Fallback**: `layanan_firebase.dart` sudah dikonfigurasi untuk selalu menggunakan data lokal JSON sebagai primary source (mencegah jeda loading). Firebase digunakan untuk seeding awal saja.
4. **Backward Compatibility**: API `AppTheme` tetap sama — semua widget tidak perlu diubah saat menambah tema baru.

---

**Versi Dokumen:** 2.0  
**Tanggal Pembaruan:** 23 Mei 2026  
**Status:** ✅ Active Development  
**Flutter Analyze:** ✅ No issues found!
