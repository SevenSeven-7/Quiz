# 📱 CARA MENJALANKAN APLIKASI DI HP

## ✅ Prasyarat

1. **HP dan PC terhubung ke WiFi yang sama**
2. **Python API server berjalan di PC**
3. **Flutter terinstall di PC**

---

## 🚀 LANGKAH-LANGKAH

### 1. Cari IP Address PC Anda

Buka Command Prompt/PowerShell di PC, jalankan:
```bash
ipconfig
```

Cari baris **IPv4 Address**, contoh: `192.168.100.14`

### 2. Update Konfigurasi API di Flutter

Buka file: `Quiz_App/lib/inti/layanan/layanan_api.dart`

Ubah line 10:
```dart
static const String baseUrl = 'http://192.168.100.14:5000';
```

**Ganti `192.168.100.14` dengan IP address PC Anda!**

### 3. Start Python API Server

```bash
cd Quiz_Dataset
python api_server.py
```

Server akan berjalan di: `http://0.0.0.0:5000` (bisa diakses dari network)

### 4. Test API dari Browser HP

Buka browser di HP, akses:
```
http://192.168.100.14:5000/health
```

Jika muncul JSON response, berarti API bisa diakses! ✅

### 5. Hubungkan HP ke PC

- **Android**: Hubungkan HP via USB, aktifkan USB Debugging
- **iOS**: Hubungkan HP via USB, trust computer

Cek device:
```bash
cd Quiz_App
flutter devices
```

### 6. Run Aplikasi di HP

```bash
cd Quiz_App
flutter run
```

Pilih device HP Anda dari list.

---

## 🐛 TROUBLESHOOTING

### Problem: "Connection refused" di HP

**Penyebab**: HP tidak bisa akses API di PC

**Solusi**:
1. Pastikan HP dan PC di WiFi yang sama
2. Cek IP address PC sudah benar di `layanan_api.dart`
3. Cek firewall Windows tidak memblokir port 5000
4. Test API dari browser HP: `http://IP_PC:5000/health`

### Problem: Firewall Windows memblokir

**Solusi**:
1. Buka Windows Defender Firewall
2. Klik "Allow an app through firewall"
3. Cari Python, centang "Private" dan "Public"
4. Atau matikan firewall sementara untuk testing

### Problem: API tidak bisa diakses dari HP

**Solusi**:
1. Pastikan API server running: `python api_server.py`
2. Cek di PC bisa akses: `http://localhost:5000/health`
3. Cek dari HP bisa akses: `http://IP_PC:5000/health`
4. Jika tidak bisa, cek firewall atau antivirus

---

## 📝 KONFIGURASI UNTUK DEVELOPMENT

### Untuk Development di PC (Chrome/Windows):
```dart
static const String baseUrl = 'http://localhost:5000';
```

### Untuk Testing di HP/Device Lain:
```dart
static const String baseUrl = 'http://192.168.100.14:5000';
```

**Ganti IP sesuai dengan IP PC Anda!**

---

## ✅ VERIFIKASI

### 1. Cek API Server
```bash
curl http://192.168.100.14:5000/health
```

Response:
```json
{
  "status": "healthy",
  "database": "connected",
  "total_questions": 14000,
  "subjects": 7
}
```

### 2. Cek dari HP
Buka browser di HP, akses:
```
http://192.168.100.14:5000/health
```

Jika muncul JSON, berarti siap! ✅

---

## 🎯 TIPS

1. **Jangan matikan PC** saat aplikasi di HP berjalan (karena API di PC)
2. **Jangan ganti WiFi** saat testing (IP bisa berubah)
3. **Untuk production**, deploy API ke server cloud (Heroku, Railway, dll)
4. **Untuk development**, gunakan `localhost` di PC

---

**SELAMAT MENCOBA!** 🚀
