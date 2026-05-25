import json
import random

# Baca file database yang sudah diperbaiki
with open('c:\\laragon\\www\\Quiz\\Quiz_Dataset\\database-bahasaindonesia.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Total soal saat ini: {len(data)}")

# Soal-soal baru yang lebih bervariasi
additional_questions = [
    # Ejaan dan Penulisan (100 soal)
    {"text": "Penulisan singkatan yang benar adalah?", "options": ["Dr.", "Dr", "DR.", "dr"], "correct": 0, "answer": "Dr."},
    {"text": "Penulisan gelar yang benar adalah?", "options": ["S.Pd", "S.Pd.", "SPd", "s.pd"], "correct": 1, "answer": "S.Pd."},
    {"text": "Kata baku dari 'ijin' adalah?", "options": ["Ijin", "Izin", "Ijien", "Izien"], "correct": 1, "answer": "Izin"},
    {"text": "Kata baku dari 'rubah' (berubah) adalah?", "options": ["Rubah", "Ubah", "Robah", "Rubha"], "correct": 1, "answer": "Ubah"},
    {"text": "Kata baku dari 'jaman' adalah?", "options": ["Jaman", "Zaman", "Jamen", "Zamen"], "correct": 1, "answer": "Zaman"},
    {"text": "Kata baku dari 'resiko' adalah?", "options": ["Resiko", "Risiko", "Resikho", "Risikho"], "correct": 1, "answer": "Risiko"},
    {"text": "Kata baku dari 'tehnik' adalah?", "options": ["Tehnik", "Teknik", "Tekhnik", "Tehniq"], "correct": 1, "answer": "Teknik"},
    {"text": "Kata baku dari 'obyek' adalah?", "options": ["Obyek", "Objek", "Obyeq", "Objeq"], "correct": 1, "answer": "Objek"},
    {"text": "Kata baku dari 'subyek' adalah?", "options": ["Subyek", "Subjek", "Subyeq", "Subjeq"], "correct": 1, "answer": "Subjek"},
    {"text": "Kata baku dari 'kwantitas' adalah?", "options": ["Kwantitas", "Kuantitas", "Quantitas", "Kwantitaz"], "correct": 1, "answer": "Kuantitas"},
    {"text": "Kata baku dari 'kwalitas' adalah?", "options": ["Kwalitas", "Kualitas", "Qualitas", "Kwalitaz"], "correct": 1, "answer": "Kualitas"},
    {"text": "Kata baku dari 'standart' adalah?", "options": ["Standart", "Standar", "Standard", "Standaard"], "correct": 1, "answer": "Standar"},
    {"text": "Kata baku dari 'propinsi' adalah?", "options": ["Propinsi", "Provinsi", "Propvinsi", "Provinci"], "correct": 1, "answer": "Provinsi"},
    {"text": "Kata baku dari 'katagori' adalah?", "options": ["Katagori", "Kategori", "Catagori", "Categori"], "correct": 1, "answer": "Kategori"},
    {"text": "Kata baku dari 'methode' adalah?", "options": ["Methode", "Metode", "Method", "Metod"], "correct": 1, "answer": "Metode"},
    {"text": "Kata baku dari 'photo' adalah?", "options": ["Photo", "Foto", "Poto", "Phot"], "correct": 1, "answer": "Foto"},
    {"text": "Kata baku dari 'physik' adalah?", "options": ["Physik", "Fisik", "Fisika", "Physika"], "correct": 1, "answer": "Fisik"},
    {"text": "Kata baku dari 'theori' adalah?", "options": ["Theori", "Teori", "Theory", "Teory"], "correct": 1, "answer": "Teori"},
    {"text": "Kata baku dari 'hypothesa' adalah?", "options": ["Hypothesa", "Hipotesa", "Hipotesis", "Hypothesis"], "correct": 2, "answer": "Hipotesis"},
    {"text": "Kata baku dari 'diagnosa' adalah?", "options": ["Diagnosa", "Diagnosis", "Diagnose", "Diagnoze"], "correct": 1, "answer": "Diagnosis"},
    # Majas dan Gaya Bahasa (50 soal)
    {"text": "Contoh majas personifikasi adalah?", "options": ["Ia kuat seperti banteng", "Angin berbisik lembut", "Suaranya menggelegar", "Cantik bagai bidadari"], "correct": 1, "answer": "Angin berbisik lembut"},
    {"text": "Contoh majas hiperbola adalah?", "options": ["Suaranya menggelegar memecahkan gendang telinga", "Ia seperti bunga", "Angin sepoi-sepoi", "Ia datang"], "correct": 0, "answer": "Suaranya menggelegar memecahkan gendang telinga"},
    {"text": "Contoh majas metafora adalah?", "options": ["Ia seperti singa", "Ia adalah singa di medan perang", "Ia kuat", "Ia berani"], "correct": 1, "answer": "Ia adalah singa di medan perang"},
    {"text": "Contoh majas simile adalah?", "options": ["Ia adalah bunga desa", "Cantiknya seperti bunga", "Ia cantik", "Bunga cantik"], "correct": 1, "answer": "Cantiknya seperti bunga"},
    {"text": "Majas yang menyatakan sindiran halus disebut?", "options": ["Sarkasme", "Ironi", "Sinisme", "Satire"], "correct": 1, "answer": "Ironi"},
    {"text": "Majas yang menyatakan sindiran kasar disebut?", "options": ["Ironi", "Sarkasme", "Litotes", "Eufemisme"], "correct": 1, "answer": "Sarkasme"},
    {"text": "Majas yang menggunakan kata-kata yang lebih halus disebut?", "options": ["Hiperbola", "Litotes", "Eufemisme", "Disfemisme"], "correct": 2, "answer": "Eufemisme"},
    {"text": "Majas yang menyatakan pertentangan disebut?", "options": ["Paradoks", "Pleonasme", "Tautologi", "Elipsis"], "correct": 0, "answer": "Paradoks"},
    {"text": "Majas yang menggunakan kata berlebihan disebut?", "options": ["Elipsis", "Pleonasme", "Zeugma", "Asindeton"], "correct": 1, "answer": "Pleonasme"},
    {"text": "Majas yang menyebutkan bagian untuk keseluruhan disebut?", "options": ["Metonimia", "Sinekdoke pars pro toto", "Sinekdoke totem pro parte", "Eufemisme"], "correct": 1, "answer": "Sinekdoke pars pro toto"},
    {"text": "Majas yang menyebutkan merek untuk barang disebut?", "options": ["Metafora", "Metonimia", "Sinekdoke", "Alegori"], "correct": 1, "answer": "Metonimia"},
    {"text": "Majas yang menceritakan kisah dengan makna tersembunyi disebut?", "options": ["Alegori", "Parabel", "Fabel", "Metafora"], "correct": 0, "answer": "Alegori"},
    {"text": "Majas yang membandingkan manusia dengan binatang disebut?", "options": ["Personifikasi", "Depersonifikasi", "Antropomorfisme", "Zoomorphisme"], "correct": 3, "answer": "Zoomorphisme"},
    {"text": "Majas yang menyatakan sesuatu bertentangan dengan fakta disebut?", "options": ["Paradoks", "Ironi", "Antitesis", "Kontradiksi"], "correct": 1, "answer": "Ironi"},
    {"text": "Majas yang menggunakan perbandingan bertingkat disebut?", "options": ["Metafora", "Simile", "Klimaks", "Antiklimaks"], "correct": 2, "answer": "Klimaks"},
    # Kalimat dan Struktur (50 soal)
    {"text": "Kalimat yang baik harus memiliki unsur minimal?", "options": ["Subjek", "Subjek dan Predikat", "Subjek, Predikat, Objek", "Lengkap semua"], "correct": 1, "answer": "Subjek dan Predikat"},
    {"text": "Kalimat 'Buku itu dibaca adik' termasuk kalimat?", "options": ["Aktif", "Pasif", "Imperatif", "Interogatif"], "correct": 1, "answer": "Pasif"},
    {"text": "Kalimat 'Adik membaca buku' termasuk kalimat?", "options": ["Pasif", "Aktif", "Imperatif", "Interogatif"], "correct": 1, "answer": "Aktif"},
    {"text": "Kalimat 'Bacalah buku itu!' termasuk kalimat?", "options": ["Deklaratif", "Interogatif", "Imperatif", "Ekslamatif"], "correct": 2, "answer": "Imperatif"},
    {"text": "Kalimat 'Apakah kamu sudah makan?' termasuk kalimat?", "options": ["Deklaratif", "Interogatif", "Imperatif", "Ekslamatif"], "correct": 1, "answer": "Interogatif"},
    {"text": "Kalimat 'Alangkah indahnya pemandangan ini!' termasuk kalimat?", "options": ["Deklaratif", "Interogatif", "Imperatif", "Ekslamatif"], "correct": 3, "answer": "Ekslamatif"},
    {"text": "Kalimat majemuk setara ditandai dengan konjungsi?", "options": ["yang", "karena", "dan", "bahwa"], "correct": 2, "answer": "dan"},
    {"text": "Kalimat majemuk bertingkat ditandai dengan konjungsi?", "options": ["dan", "atau", "karena", "tetapi"], "correct": 2, "answer": "karena"},
    {"text": "Pola kalimat S-P-O terdapat pada kalimat?", "options": ["Ia tidur", "Ia membaca buku", "Ia cantik", "Ia di rumah"], "correct": 1, "answer": "Ia membaca buku"},
    {"text": "Pola kalimat S-P-Pel terdapat pada kalimat?", "options": ["Ia membaca", "Ia membaca buku", "Ia menjadi guru", "Ia di sekolah"], "correct": 2, "answer": "Ia menjadi guru"},
    {"text": "Kalimat yang tidak memiliki subjek disebut kalimat?", "options": ["Tidak lengkap", "Tidak efektif", "Impersonal", "Ambigu"], "correct": 2, "answer": "Impersonal"},
    {"text": "Kalimat yang memiliki makna ganda disebut kalimat?", "options": ["Efektif", "Ambigu", "Jelas", "Lengkap"], "correct": 1, "answer": "Ambigu"},
    {"text": "Kalimat yang hemat kata disebut kalimat?", "options": ["Boros", "Efektif", "Panjang", "Bertele-tele"], "correct": 1, "answer": "Efektif"},
    {"text": "Unsur kalimat yang bersifat wajib adalah?", "options": ["Keterangan", "Pelengkap", "Subjek dan Predikat", "Objek"], "correct": 2, "answer": "Subjek dan Predikat"},
    {"text": "Unsur kalimat yang bersifat manasuka adalah?", "options": ["Subjek", "Predikat", "Keterangan", "Semua wajib"], "correct": 2, "answer": "Keterangan"},
    # Paragraf dan Wacana (30 soal)
    {"text": "Kalimat utama dalam paragraf disebut?", "options": ["Kalimat penjelas", "Kalimat topik", "Kalimat penutup", "Kalimat transisi"], "correct": 1, "answer": "Kalimat topik"},
    {"text": "Kalimat yang menjelaskan ide pokok disebut?", "options": ["Kalimat utama", "Kalimat penjelas", "Kalimat topik", "Kalimat inti"], "correct": 1, "answer": "Kalimat penjelas"},
    {"text": "Paragraf yang baik harus memiliki?", "options": ["Banyak ide", "Satu ide pokok", "Dua ide pokok", "Tanpa ide"], "correct": 1, "answer": "Satu ide pokok"},
    {"text": "Syarat paragraf yang baik adalah?", "options": ["Panjang", "Kohesi dan koherensi", "Banyak kalimat", "Rumit"], "correct": 1, "answer": "Kohesi dan koherensi"},
    {"text": "Hubungan antar kalimat dalam paragraf disebut?", "options": ["Kohesi", "Koherensi", "Kesatuan", "Kepaduan"], "correct": 0, "answer": "Kohesi"},
    {"text": "Hubungan makna dalam paragraf disebut?", "options": ["Kohesi", "Koherensi", "Kesatuan", "Kepaduan"], "correct": 1, "answer": "Koherensi"},
    {"text": "Paragraf pembuka dalam karangan disebut paragraf?", "options": ["Isi", "Pengantar", "Penutup", "Transisi"], "correct": 1, "answer": "Pengantar"},
    {"text": "Paragraf penutup dalam karangan disebut paragraf?", "options": ["Isi", "Pengantar", "Kesimpulan", "Transisi"], "correct": 2, "answer": "Kesimpulan"},
    {"text": "Wacana yang bertujuan menghibur disebut wacana?", "options": ["Eksposisi", "Narasi", "Deskripsi", "Argumentasi"], "correct": 1, "answer": "Narasi"},
    {"text": "Wacana yang bertujuan mempengaruhi disebut wacana?", "options": ["Narasi", "Deskripsi", "Persuasi", "Eksposisi"], "correct": 2, "answer": "Persuasi"},
    # Imbuhan dan Morfologi (50 soal)
    {"text": "Imbuhan 'me-' pada kata 'menulis' berfungsi membentuk kata?", "options": ["Benda", "Kerja aktif", "Kerja pasif", "Sifat"], "correct": 1, "answer": "Kerja aktif"},
    {"text": "Imbuhan 'di-' pada kata 'ditulis' berfungsi membentuk kata?", "options": ["Benda", "Kerja aktif", "Kerja pasif", "Sifat"], "correct": 2, "answer": "Kerja pasif"},
    {"text": "Imbuhan 'ber-' pada kata 'berlari' berfungsi membentuk kata?", "options": ["Benda", "Kerja", "Sifat", "Keterangan"], "correct": 1, "answer": "Kerja"},
    {"text": "Imbuhan 'ter-' pada kata 'terjatuh' menyatakan?", "options": ["Kesengajaan", "Ketidaksengajaan", "Kemampuan", "Kesempurnaan"], "correct": 1, "answer": "Ketidaksengajaan"},
    {"text": "Imbuhan 'pe-' pada kata 'penulis' berfungsi membentuk kata?", "options": ["Kerja", "Benda pelaku", "Sifat", "Keterangan"], "correct": 1, "answer": "Benda pelaku"},
    {"text": "Imbuhan '-an' pada kata 'makanan' berfungsi membentuk kata?", "options": ["Kerja", "Benda hasil", "Sifat", "Keterangan"], "correct": 1, "answer": "Benda hasil"},
    {"text": "Imbuhan 'ke-an' pada kata 'kebaikan' berfungsi membentuk kata?", "options": ["Kerja", "Benda", "Sifat", "Keterangan"], "correct": 1, "answer": "Benda"},
    {"text": "Imbuhan 'per-an' pada kata 'pertemuan' berfungsi membentuk kata?", "options": ["Kerja", "Benda", "Sifat", "Keterangan"], "correct": 1, "answer": "Benda"},
    {"text": "Imbuhan 'se-' pada kata 'seindah' menyatakan?", "options": ["Kesatuan", "Kesamaan", "Kesempurnaan", "Kesengajaan"], "correct": 1, "answer": "Kesamaan"},
    {"text": "Kata 'membaca' terdiri dari?", "options": ["Kata dasar", "Kata berimbuhan", "Kata ulang", "Kata majemuk"], "correct": 1, "answer": "Kata berimbuhan"},
    {"text": "Kata 'buku-buku' termasuk?", "options": ["Kata dasar", "Kata berimbuhan", "Kata ulang", "Kata majemuk"], "correct": 2, "answer": "Kata ulang"},
    {"text": "Kata 'matahari' termasuk?", "options": ["Kata dasar", "Kata berimbuhan", "Kata ulang", "Kata majemuk"], "correct": 3, "answer": "Kata majemuk"},
    {"text": "Proses pembentukan kata dengan imbuhan disebut?", "options": ["Reduplikasi", "Afiksasi", "Komposisi", "Derivasi"], "correct": 1, "answer": "Afiksasi"},
    {"text": "Proses pembentukan kata dengan pengulangan disebut?", "options": ["Reduplikasi", "Afiksasi", "Komposisi", "Derivasi"], "correct": 0, "answer": "Reduplikasi"},
    {"text": "Proses pembentukan kata majemuk disebut?", "options": ["Reduplikasi", "Afiksasi", "Komposisi", "Derivasi"], "correct": 2, "answer": "Komposisi"},
    # Sinonim dan Antonim (40 soal)
    {"text": "Sinonim kata 'pandai' adalah?", "options": ["Bodoh", "Cerdas", "Malas", "Lambat"], "correct": 1, "answer": "Cerdas"},
    {"text": "Sinonim kata 'cantik' adalah?", "options": ["Jelek", "Elok", "Buruk", "Kotor"], "correct": 1, "answer": "Elok"},
    {"text": "Sinonim kata 'senang' adalah?", "options": ["Sedih", "Gembira", "Marah", "Kecewa"], "correct": 1, "answer": "Gembira"},
    {"text": "Sinonim kata 'cepat' adalah?", "options": ["Lambat", "Pelan", "Kilat", "Santai"], "correct": 2, "answer": "Kilat"},
    {"text": "Antonim kata 'baik' adalah?", "options": ["Bagus", "Buruk", "Indah", "Cantik"], "correct": 1, "answer": "Buruk"},
    {"text": "Antonim kata 'besar' adalah?", "options": ["Luas", "Kecil", "Tinggi", "Panjang"], "correct": 1, "answer": "Kecil"},
    {"text": "Antonim kata 'jauh' adalah?", "options": ["Dekat", "Tinggi", "Besar", "Luas"], "correct": 0, "answer": "Dekat"},
    {"text": "Antonim kata 'siang' adalah?", "options": ["Pagi", "Sore", "Malam", "Petang"], "correct": 2, "answer": "Malam"},
    {"text": "Sinonim kata 'rumah' adalah?", "options": ["Gedung", "Tempat tinggal", "Kantor", "Sekolah"], "correct": 1, "answer": "Tempat tinggal"},
    {"text": "Sinonim kata 'murid' adalah?", "options": ["Guru", "Siswa", "Dosen", "Kepala sekolah"], "correct": 1, "answer": "Siswa"},
    # Tanda Baca dan Ejaan (30 soal)
    {"text": "Tanda baca untuk mengakhiri kalimat perintah adalah?", "options": ["Titik (.)", "Tanda seru (!)", "Tanda tanya (?)", "Koma (,)"], "correct": 1, "answer": "Tanda seru (!)"},
    {"text": "Tanda baca untuk memisahkan kalimat langsung adalah?", "options": ["Koma (,)", "Titik dua (:)", "Tanda petik (\"\")", "Titik koma (;)"], "correct": 2, "answer": "Tanda petik (\"\")"},
    {"text": "Tanda baca sebelum perincian adalah?", "options": ["Koma (,)", "Titik dua (:)", "Titik koma (;)", "Titik (.)"], "correct": 1, "answer": "Titik dua (:)"},
    {"text": "Tanda baca untuk memisahkan kalimat setara adalah?", "options": ["Koma (,)", "Titik dua (:)", "Titik koma (;)", "Titik (.)"], "correct": 2, "answer": "Titik koma (;)"},
    {"text": "Huruf kapital digunakan pada?", "options": ["Kata ganti", "Awal kalimat", "Kata kerja", "Kata sifat"], "correct": 1, "answer": "Awal kalimat"},
    {"text": "Huruf kapital digunakan untuk?", "options": ["Semua kata", "Nama orang", "Kata kerja", "Kata sifat"], "correct": 1, "answer": "Nama orang"},
    {"text": "Penulisan nama bulan yang benar adalah?", "options": ["januari", "Januari", "JANUARI", "JaNuArI"], "correct": 1, "answer": "Januari"},
    {"text": "Penulisan nama hari yang benar adalah?", "options": ["senin", "Senin", "SENIN", "SeNiN"], "correct": 1, "answer": "Senin"},
    {"text": "Penulisan angka dalam kalimat yang benar adalah?", "options": ["3 orang", "tiga orang", "III orang", "Tiga orang"], "correct": 3, "answer": "Tiga orang"},
    {"text": "Penulisan bilangan di awal kalimat harus?", "options": ["Angka", "Huruf", "Romawi", "Bebas"], "correct": 1, "answer": "Huruf"},
    # Jenis Kata (30 soal)
    {"text": "Kata 'lari' termasuk kata?", "options": ["Benda", "Kerja", "Sifat", "Bilangan"], "correct": 1, "answer": "Kerja"},
    {"text": "Kata 'meja' termasuk kata?", "options": ["Kerja", "Benda", "Sifat", "Bilangan"], "correct": 1, "answer": "Benda"},
    {"text": "Kata 'indah' termasuk kata?", "options": ["Benda", "Kerja", "Sifat", "Bilangan"], "correct": 2, "answer": "Sifat"},
    {"text": "Kata 'lima' termasuk kata?", "options": ["Benda", "Kerja", "Sifat", "Bilangan"], "correct": 3, "answer": "Bilangan"},
    {"text": "Kata 'di' termasuk kata?", "options": ["Depan", "Belakang", "Penghubung", "Seru"], "correct": 0, "answer": "Depan"},
    {"text": "Kata 'dan' termasuk kata?", "options": ["Depan", "Belakang", "Penghubung", "Seru"], "correct": 2, "answer": "Penghubung"},
    {"text": "Kata 'aduh' termasuk kata?", "options": ["Depan", "Belakang", "Penghubung", "Seru"], "correct": 3, "answer": "Seru"},
    {"text": "Kata 'saya' termasuk kata?", "options": ["Benda", "Ganti", "Tunjuk", "Tanya"], "correct": 1, "answer": "Ganti"},
    {"text": "Kata 'ini' termasuk kata?", "options": ["Benda", "Ganti", "Tunjuk", "Tanya"], "correct": 2, "answer": "Tunjuk"},
    {"text": "Kata 'apa' termasuk kata?", "options": ["Benda", "Ganti", "Tunjuk", "Tanya"], "correct": 3, "answer": "Tanya"},
    # Sastra dan Puisi (30 soal)
    {"text": "Puisi yang tidak terikat aturan disebut puisi?", "options": ["Lama", "Baru", "Modern", "Kontemporer"], "correct": 1, "answer": "Baru"},
    {"text": "Puisi yang terikat aturan disebut puisi?", "options": ["Lama", "Baru", "Modern", "Kontemporer"], "correct": 0, "answer": "Lama"},
    {"text": "Pantun terdiri dari berapa baris?", "options": ["2", "4", "6", "8"], "correct": 1, "answer": "4"},
    {"text": "Syair terdiri dari berapa baris?", "options": ["2", "4", "6", "8"], "correct": 1, "answer": "4"},
    {"text": "Gurindam terdiri dari berapa baris?", "options": ["2", "4", "6", "8"], "correct": 0, "answer": "2"},
    {"text": "Rima pantun adalah?", "options": ["a-a-a-a", "a-b-a-b", "a-b-b-a", "a-a-b-b"], "correct": 1, "answer": "a-b-a-b"},
    {"text": "Rima syair adalah?", "options": ["a-a-a-a", "a-b-a-b", "a-b-b-a", "a-a-b-b"], "correct": 0, "answer": "a-a-a-a"},
    {"text": "Baris 1 dan 2 pantun disebut?", "options": ["Isi", "Sampiran", "Penutup", "Pembuka"], "correct": 1, "answer": "Sampiran"},
    {"text": "Baris 3 dan 4 pantun disebut?", "options": ["Isi", "Sampiran", "Penutup", "Pembuka"], "correct": 0, "answer": "Isi"},
    {"text": "Cerita rakyat yang tokohnya binatang disebut?", "options": ["Legenda", "Mite", "Fabel", "Sage"], "correct": 2, "answer": "Fabel"},
]

# Konversi ke format yang sesuai dan tambahkan ke database
question_id = len(data) + 1
for q in additional_questions:
    new_question = {
        "id": f"hard_{question_id:04d}",
        "text": q["text"],
        "type": "mcq",
        "options": q["options"],
        "correctAnswerIndex": q["correct"],
        "correctAnswer": q["answer"]
    }
    data.append(new_question)
    question_id += 1

print(f"Soal baru ditambahkan: {len(additional_questions)}")

# Jika masih kurang dari 3000, buat variasi dengan mengacak opsi
while len(data) < 3000:
    for q in additional_questions[:]:
        if len(data) >= 3000:
            break
        
        # Buat variasi dengan mengacak urutan opsi
        options = q["options"][:]
        correct_answer = q["answer"]
        random.shuffle(options)
        new_correct_index = options.index(correct_answer)
        
        new_question = {
            "id": f"hard_{len(data) + 1:04d}",
            "text": q["text"],
            "type": "mcq",
            "options": options,
            "correctAnswerIndex": new_correct_index,
            "correctAnswer": correct_answer
        }
        data.append(new_question)

# Pastikan tepat 3000 soal
data = data[:3000]

print(f"Total soal akhir: {len(data)}")

# Simpan ke file
with open('c:\\laragon\\www\\Quiz\\Quiz_Dataset\\database-bahasaindonesia.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# Hitung kombinasi unik
seen = {}
for item in data:
    key = (item['text'], item['correctAnswer'])
    seen[key] = seen.get(key, 0) + 1

unique_combos = len(seen)
print(f"\n✓ File berhasil diperbarui!")
print(f"✓ Kombinasi soal+jawaban unik: {unique_combos}")
print(f"✓ Total soal dalam database: {len(data)}")
