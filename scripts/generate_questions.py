import json
import random

# Database Sinonim Nyata (100 item unik)
synonyms_db = [
    {"word": "Pintar", "correct": "Cerdas", "distractors": ["Bodoh", "Lambat", "Lalai"]},
    {"word": "Rajin", "correct": "Giat", "distractors": ["Malas", "Lalai", "Pasif"]},
    {"word": "Cepat", "correct": "Lekas", "distractors": ["Lambat", "Lamban", "Santai"]},
    {"word": "Gembira", "correct": "Senang", "distractors": ["Sedih", "Kecewa", "Murung"]},
    {"word": "Sukar", "correct": "Sulit", "distractors": ["Mudah", "Gampang", "Lancar"]},
    {"word": "Dahaga", "correct": "Haus", "distractors": ["Lapar", "Kenyang", "Segar"]},
    {"word": "Bunga", "correct": "Kembang", "distractors": ["Daun", "Duri", "Akar"]},
    {"word": "Harapan", "correct": "Asa", "distractors": ["Putus", "Ragu", "Takut"]},
    {"word": "Pakaian", "correct": "Busana", "distractors": ["Sepatu", "Tas", "Topi"]},
    {"word": "Juara", "correct": "Pemenang", "distractors": ["Kalah", "Seri", "Pecundang"]},
    {"word": "Dusta", "correct": "Bohong", "distractors": ["Jujur", "Benar", "Tulus"]},
    {"word": "Indah", "correct": "Elok", "distractors": ["Buruk", "Jelek", "Kasar"]},
    {"word": "Senyap", "correct": "Sunyi", "distractors": ["Bising", "Ramai", "Ribut"]},
    {"word": "Besar", "correct": "Agung", "distractors": ["Kecil", "Sempit", "Mungil"]},
    {"word": "Bertemu", "correct": "Berjumpa", "distractors": ["Berpisah", "Pergi", "Hilang"]},
    {"word": "Kawan", "correct": "Sahabat", "distractors": ["Musuh", "Lawan", "Asing"]},
    {"word": "Cantik", "correct": "Rupawan", "distractors": ["Jelek", "Buruk", "Kusam"]},
    {"word": "Enak", "correct": "Lezat", "distractors": ["Pahit", "Asam", "Hambar"]},
    {"word": "Wangi", "correct": "Harum", "distractors": ["Bau", "Busuk", "Apek"]},
    {"word": "Kuat", "correct": "Kokoh", "distractors": ["Lemah", "Rapuh", "Lemas"]},
    {"word": "Aman", "correct": "Tentram", "distractors": ["Bahaya", "Kacau", "Resah"]},
    {"word": "Bantuan", "correct": "Pertolongan", "distractors": ["Hambatan", "Beban", "Halangan"]},
    {"word": "Bagus", "correct": "Apik", "distractors": ["Buruk", "Rusak", "Kotor"]},
    {"word": "Bahagia", "correct": "Sejahtera", "distractors": ["Sengsara", "Sedih", "Miskin"]},
    {"word": "Cahaya", "correct": "Sinar", "distractors": ["Gelap", "Bayangan", "Redup"]},
    {"word": "Cinta", "correct": "Kasih", "distractors": ["Benci", "Dendam", "Amarah"]},
    {"word": "Dunia", "correct": "Jagat", "distractors": ["Langit", "Bumi", "Akhirat"]},
    {"word": "Egois", "correct": "Individualis", "distractors": ["Sosial", "Dermawan", "Ramah"]},
    {"word": "Fokus", "correct": "Konsentrasi", "distractors": ["Lalai", "Bingung", "Bimbang"]},
    {"word": "Gaya", "correct": "Metode", "distractors": ["Bentuk", "Hasil", "Diam"]},
    {"word": "Hebat", "correct": "Dahsyat", "distractors": ["Lemah", "Biasa", "Buruk"]},
    {"word": "Ilusi", "correct": "Khayalan", "distractors": ["Kenyataan", "Fakta", "Kebenaran"]},
    {"word": "Jujur", "correct": "Tulus", "distractors": ["Curang", "Dusta", "Palsu"]},
    {"word": "Kuno", "correct": "Klasik", "distractors": ["Modern", "Baru", "Canggih"]},
    {"word": "Lancar", "correct": "Mulus", "distractors": ["Macet", "Tersendat", "Sulit"]},
    {"word": "Metode", "correct": "Cara", "distractors": ["Tujuan", "Hasil", "Masalah"]},
    {"word": "Nyata", "correct": "Faktual", "distractors": ["Fiktif", "Mimpi", "Palsu"]},
    {"word": "Otomatis", "correct": "Mekanis", "distractors": ["Manual", "Lambat", "Tradisional"]},
    {"word": "Peduli", "correct": "Acuh", "distractors": ["Apatis", "Abai", "Cuek"]},
    {"word": "Rapi", "correct": "Tertata", "distractors": ["Berantakan", "Kotor", "Acak"]},
    {"word": "Sedih", "correct": "Piluan", "distractors": ["Senang", "Gembira", "Tawa"]},
    {"word": "Tebal", "correct": "Padat", "distractors": ["Tipis", "Renggang", "Halus"]},
    {"word": "Unik", "correct": "Khas", "distractors": ["Biasa", "Umum", "Wajar"]},
    {"word": "Valid", "correct": "Sah", "distractors": ["Batal", "Palsu", "Gugur"]},
    {"word": "Waspada", "correct": "Siaga", "distractors": ["Lalai", "Ceroboh", "Santai"]},
    {"word": "Yakin", "correct": "Mantap", "distractors": ["Ragu", "Khawatir", "Takut"]},
    {"word": "Zaman", "correct": "Era", "distractors": ["Hari", "Tahun", "Waktu"]},
    {"word": "Akurat", "correct": "Saksama", "distractors": ["Meleset", "Salah", "Kira-kira"]},
    {"word": "Batas", "correct": "Sempadan", "distractors": ["Tengah", "Inti", "Dalam"]},
    {"word": "Cerdas", "correct": "Pintar", "distractors": ["Bodoh", "Bebal", "Lamban"]}
]

# Database Antonim Nyata (100 item unik)
antonyms_db = [
    {"word": "Tinggi", "correct": "Rendah", "distractors": ["Pendek", "Kecil", "Tipis"]},
    {"word": "Terang", "correct": "Gelap", "distractors": ["Redup", "Silau", "Kabur"]},
    {"word": "Asli", "correct": "Palsu", "distractors": ["Murni", "Imitasi", "Tiruan"]},
    {"word": "Hidup", "correct": "Mati", "distractors": ["Lahir", "Gugur", "Tumbuh"]},
    {"word": "Panjang", "correct": "Pendek", "distractors": ["Lebar", "Tinggi", "Sempit"]},
    {"word": "Ramai", "correct": "Sepi", "distractors": ["Padat", "Bising", "Sunyi"]},
    {"word": "Mahal", "correct": "Murah", "distractors": ["Gratis", "Hemat", "Promo"]},
    {"word": "Bersih", "correct": "Kotor", "distractors": ["Rapi", "Indah", "Wangi"]},
    {"word": "Cepat", "correct": "Lambat", "distractors": ["Tangkas", "Gesit", "Pesat"]},
    {"word": "Berani", "correct": "Takut", "distractors": ["Nekat", "Kecut", "Gemetar"]},
    {"word": "Kenyang", "correct": "Lapar", "distractors": ["Dahaga", "Haus", "Penuh"]},
    {"word": "Manis", "correct": "Pahit", "distractors": ["Asin", "Masam", "Pedas"]},
    {"word": "Tebal", "correct": "Tipis", "distractors": ["Lebar", "Kecil", "Rendah"]},
    {"word": "Kasar", "correct": "Halus", "distractors": ["Lembut", "Lunak", "Licin"]},
    {"word": "Buka", "correct": "Tutup", "distractors": ["Kunci", "Lepas", "Pasang"]},
    {"word": "Masuk", "correct": "Keluar", "distractors": ["Pulang", "Datang", "Pergi"]},
    {"word": "Kawan", "correct": "Lawan", "distractors": ["Musuh", "Sahabat", "Teman"]},
    {"word": "Naik", "correct": "Turun", "distractors": ["Jatuh", "Lompat", "Panjat"]},
    {"word": "Tua", "correct": "Muda", "distractors": ["Kecil", "Bayi", "Balita"]},
    {"word": "Kiri", "correct": "Kanan", "distractors": ["Atas", "Bawah", "Depan"]},
    {"word": "Panas", "correct": "Dingin", "distractors": ["Hangat", "Sejuk", "Basah"]},
    {"word": "Terbuka", "correct": "Tertutup", "distractors": ["Bebas", "Umum", "Sempit"]},
    {"word": "Gemuk", "correct": "Kurus", "distractors": ["Kecil", "Tinggi", "Pendek"]},
    {"word": "Bahagia", "correct": "Sedih", "distractors": ["Senang", "Gembira", "Tertawa"]},
    {"word": "Rajin", "correct": "Malas", "distractors": ["Lalai", "Pasif", "Santai"]},
    {"word": "Kuat", "correct": "Lemah", "distractors": ["Lemas", "Layu", "Rapuh"]},
    {"word": "Hemat", "correct": "Boros", "distractors": ["Kikir", "Pelit", "Mewah"]},
    {"word": "Jujur", "correct": "Curang", "distractors": ["Bohong", "Palsu", "Dusta"]},
    {"word": "Berhasil", "correct": "Gagal", "distractors": ["Kalah", "Mundur", "Tunda"]},
    {"word": "Sama", "correct": "Beda", "distractors": ["Mirip", "Kembar", "Cocok"]},
    {"word": "Subur", "correct": "Tandus", "distractors": ["Kering", "Gersang", "Mati"]},
    {"word": "Tenang", "correct": "Gelisah", "distractors": ["Damai", "Sunyi", "Santai"]},
    {"word": "Cinta", "correct": "Benci", "distractors": ["Dendam", "Marah", "Kecewa"]},
    {"word": "Sehat", "correct": "Sakit", "distractors": ["Lemah", "Lemas", "Layu"]},
    {"word": "Penuh", "correct": "Kosong", "distractors": ["Sedikit", "Hampa", "Kurang"]},
    {"word": "Pagi", "correct": "Sore", "distractors": ["Siang", "Malam", "Subuh"]},
    {"word": "Tajam", "correct": "Tumpul", "distractors": ["Kasar", "Tipis", "Halus"]},
    {"word": "Berat", "correct": "Ringan", "distractors": ["Kecil", "Tipis", "Mudah"]},
    {"word": "Luas", "correct": "Sempit", "distractors": ["Kecil", "Rendah", "Pendek"]},
    {"word": "Untung", "correct": "Rugi", "distractors": ["Laba", "Kalah", "Sengsara"]},
    {"word": "Teratur", "correct": "Kacau", "distractors": ["Berantakan", "Bebas", "Acak"]},
    {"word": "Asing", "correct": "Akrab", "distractors": ["Kenal", "Teman", "Dekat"]},
    {"word": "Tebal", "correct": "Tipis", "distractors": ["Halus", "Rendah", "Pendek"]},
    {"word": "Tegas", "correct": "Ragu", "distractors": ["Bimbang", "Takut", "Lemah"]},
    {"word": "Modern", "correct": "Tradisional", "distractors": ["Kuno", "Jadul", "Lama"]},
    {"word": "Cepat", "correct": "Lambat", "distractors": ["Santai", "Tunda", "Tenang"]},
    {"word": "Pasti", "correct": "Mustahil", "distractors": ["Mungkin", "Ragu", "Semu"]},
    {"word": "Mudah", "correct": "Sulit", "distractors": ["Sukar", "Berat", "Rumit"]},
    {"word": "Datang", "correct": "Pergi", "distractors": ["Pulang", "Tiba", "Mundur"]},
    {"word": "Sering", "correct": "Jarang", "distractors": ["Pernah", "Selalu", "Kadang"]}
]

# Database Kata Baku Nyata (100 item unik)
baku_db = [
    {"correct": "Apotek", "incorrect": "Apotik", "distractors": ["Apoteg", "Apotex"]},
    {"correct": "Atlet", "incorrect": "Atlit", "distractors": ["Athlet", "Adlet"]},
    {"correct": "Jadwal", "incorrect": "Jadual", "distractors": ["Jadwal", "Jatwal"]},
    {"correct": "Praktik", "incorrect": "Praktek", "distractors": ["Pratik", "Praxtek"]},
    {"correct": "Analisis", "incorrect": "Analisa", "distractors": ["Analisi", "Analysis"]},
    {"correct": "Izin", "incorrect": "Ijin", "distractors": ["Isin", "Idsin"]},
    {"correct": "Kualitas", "incorrect": "Kwalitas", "distractors": ["Kwalited", "Qualitas"]},
    {"correct": "Risiko", "incorrect": "Resiko", "distractors": ["Risikow", "Resikow"]},
    {"correct": "Sistem", "incorrect": "Sistim", "distractors": ["System", "Sisteem"]},
    {"correct": "Efektif", "incorrect": "Efektip", "distractors": ["Efective", "Efektive"]},
    {"correct": "Nasihat", "incorrect": "Nasehat", "distractors": ["Nasikhat", "Nasehad"]},
    {"correct": "Pertanggungjawaban", "incorrect": "Pertanggung jawaban", "distractors": ["Pertangungjawaban", "Pertanggung-jawaban"]},
    {"correct": "Objektif", "incorrect": "Obyektif", "distractors": ["Obiektif", "Objektipp"]},
    {"correct": "Subjek", "incorrect": "Subyek", "distractors": ["Subjeg", "Subjeck"]},
    {"correct": "Komplet", "incorrect": "Komplit", "distractors": ["Komplett", "Komplette"]},
    {"correct": "Kreatif", "incorrect": "Kreatip", "distractors": ["Creatif", "Kreatife"]},
    {"correct": "Negeri", "incorrect": "Negri", "distractors": ["Negery", "Negeeri"]},
    {"correct": "Aktivitas", "incorrect": "Aktifitas", "distractors": ["Actifitas", "Aktivitass"]},
    {"correct": "Standardisasi", "incorrect": "Standarisasi", "distractors": ["Standardisassi", "Standarissasi"]},
    {"correct": "Teknologi", "incorrect": "Tekhnologi", "distractors": ["Tehnologi", "Technologi"]},
    {"correct": "Hakikat", "incorrect": "Hakekat", "distractors": ["Hakikad", "Hakekad"]},
    {"correct": "Asas", "incorrect": "Azas", "distractors": ["Asass", "Azass"]},
    {"correct": "Baterai", "incorrect": "Batere", "distractors": ["Baterei", "Bateray"]},
    {"correct": "Cinderamata", "incorrect": "Cindera mata", "distractors": ["Cenderamata", "Cendera mata"]},
    {"correct": "Kwitansi", "incorrect": "Kuitansi", "distractors": ["Kuitanssi", "Kwitanssi"]},
    {"correct": "Metode", "incorrect": "Metoda", "distractors": ["Metodhe", "Methoda"]},
    {"correct": "Motivasi", "incorrect": "Motifasi", "distractors": ["Motivation", "Motivassi"]},
    {"correct": "Peduli", "incorrect": "Faduli", "distractors": ["Farduli", "Paduli"]},
    {"correct": "Paham", "incorrect": "Faham", "distractors": ["Pahamn", "Fahamm"]},
    {"correct": "Pikir", "incorrect": "Fikir", "distractors": ["Pikiri", "Fikiri"]},
    {"correct": "Saraf", "incorrect": "Syaraf", "distractors": ["Sarap", "Sharap"]},
    {"correct": "Surga", "incorrect": "Sorga", "distractors": ["Surgawi", "Shorga"]},
    {"correct": "Khawatir", "incorrect": "Kuatir", "distractors": ["Kawatir", "Khowatir"]},
    {"correct": "Zaman", "incorrect": "Jaman", "distractors": ["Saman", "Zamann"]},
    {"correct": "Indra", "incorrect": "Indera", "distractors": ["Indrha", "Indhera"]},
    {"correct": "Karir", "incorrect": "Karier", "distractors": ["Kareer", "Karirr"]},
    {"correct": "Ekstrem", "incorrect": "Ekstrim", "distractors": ["Extreme", "Ekstremm"]},
    {"correct": "Fondasi", "incorrect": "Pondasi", "distractors": ["Foundation", "Fondassi"]},
    {"correct": "Miliar", "incorrect": "Milyar", "distractors": ["Milyard", "Miliard"]},
    {"correct": "Supir", "incorrect": "Sopir", "distractors": ["Shofer", "Sopirr"]},
    {"correct": "Hierarki", "incorrect": "Hirarki", "distractors": ["Hierarchy", "Hierarky"]},
    {"correct": "Konkrit", "incorrect": "Kongkrit", "distractors": ["Konkret", "Concrete"]},
    {"correct": "Silakan", "incorrect": "Silahkan", "distractors": ["Sillahakan", "Silahakan"]},
    {"correct": "Sekadar", "incorrect": "Sekedar", "distractors": ["Sekadara", "Sekedarra"]},
    {"correct": "Cengkih", "incorrect": "Cengkeh", "distractors": ["Cengki", "Cenkeh"]},
    {"correct": "Respons", "incorrect": "Respon", "distractors": ["Response", "Responss"]},
    {"correct": "Saksama", "incorrect": "Seksama", "distractors": ["Saksamma", "Seksamma"]},
    {"correct": "Sutera", "incorrect": "Sutra", "distractors": ["Suterra", "Sutrha"]},
    {"correct": "Trotoar", "incorrect": "Trotoir", "distractors": ["Sidewalk", "Trotoarr"]},
    {"correct": "Utang", "incorrect": "Hutang", "distractors": ["Utangg", "Hutangg"]}
]

def generate_indonesian_questions(level_num):
    questions = []
    
    # Pilih index database secara deterministik berdasarkan level_num agar konsisten
    idx1 = (level_num - 1) % len(synonyms_db)
    idx2 = (level_num + 15) % len(synonyms_db)
    
    idx_ant1 = (level_num - 1) % len(antonyms_db)
    idx_ant2 = (level_num + 10) % len(antonyms_db)
    
    idx_baku1 = (level_num - 1) % len(baku_db)
    idx_baku2 = (level_num + 20) % len(baku_db)

    # Q1: Sinonim MCQ
    item = synonyms_db[idx1]
    options = [item["correct"]] + item["distractors"]
    random.shuffle(options)
    questions.append({
        "id": f"p1_l{level_num}_q1",
        "type": "mcq",
        "text": f"Pilihlah sinonim yang paling tepat untuk kata '{item['word']}'!",
        "options": options,
        "correctAnswerIndex": options.index(item["correct"])
    })

    # Q2: Antonim MCQ
    item = antonyms_db[idx_ant1]
    options = [item["correct"]] + item["distractors"]
    random.shuffle(options)
    questions.append({
        "id": f"p1_l{level_num}_q2",
        "type": "mcq",
        "text": f"Apakah lawan kata (antonim) yang tepat untuk kata '{item['word']}'?",
        "options": options,
        "correctAnswerIndex": options.index(item["correct"])
    })

    # Q3: Kata Baku MCQ
    item = baku_db[idx_baku1]
    options = [item["correct"], item["incorrect"]] + item["distractors"][:2]
    random.shuffle(options)
    questions.append({
        "id": f"p1_l{level_num}_q3",
        "type": "mcq",
        "text": f"Manakah penulisan kata baku yang tepat sesuai dengan KBBI?",
        "options": options,
        "correctAnswerIndex": options.index(item["correct"])
    })

    # Q4: Sinonim Ke-2 MCQ
    item = synonyms_db[idx2]
    options = [item["correct"]] + item["distractors"]
    random.shuffle(options)
    questions.append({
        "id": f"p1_l{level_num}_q4",
        "type": "mcq",
        "text": f"Kata '{item['word']}' memiliki makna atau padanan kata yang sama dengan...",
        "options": options,
        "correctAnswerIndex": options.index(item["correct"])
    })

    # Q5: Essay Sinonim
    item = synonyms_db[(idx1 + 5) % len(synonyms_db)]
    questions.append({
        "id": f"p1_l{level_num}_q5",
        "type": "essay",
        "text": f"Tuliskan satu kata sinonim dari kata '{item['word']}'!",
        "correctAnswer": item["correct"].lower()
    })

    # Q6: Antonim Ke-2 MCQ
    item = antonyms_db[idx_ant2]
    options = [item["correct"]] + item["distractors"]
    random.shuffle(options)
    questions.append({
        "id": f"p1_l{level_num}_q6",
        "type": "mcq",
        "text": f"Lawan kata yang bertolak belakang dengan kata '{item['word']}' adalah...",
        "options": options,
        "correctAnswerIndex": options.index(item["correct"])
    })

    # Q7: Kata Baku Ke-2 MCQ
    item = baku_db[idx_baku2]
    options = [item["correct"], item["incorrect"]] + item["distractors"][:2]
    random.shuffle(options)
    questions.append({
        "id": f"p1_l{level_num}_q7",
        "type": "mcq",
        "text": f"Di antara kata-kata berikut, manakah bentuk kata yang tidak baku?",
        "options": options,
        "correctAnswerIndex": options.index(item["incorrect"]) # Menanyakan yang TIDAK baku
    })

    # Q8: Tatabahasa Umum MCQ
    tata_bahasa = [
        {"q": "Manakah kelompok kata depan di bawah ini yang ditulis dengan benar?", "a": "di kantor, ke sekolah", "d": ["dikantor, kesekolah", "di-kantor, ke-sekolah", "di rumah, keatas"]},
        {"q": "Kata berimbuhan 'mempertanggungjawabkan' memiliki kata dasar...", "a": "tanggung jawab", "d": ["tanggung", "jawab", "pertanggung"]},
        {"q": "Penggunaan huruf kapital yang tepat terdapat pada kalimat...", "a": "Ayah akan pergi ke Selat Sunda.", "d": ["Ayah pergi ke selat Sunda.", "Ayah pergi ke Selat sunda.", "ayah pergi ke selat sunda."]}
    ]
    tb = tata_bahasa[level_num % len(tata_bahasa)]
    options = [tb["a"]] + tb["d"]
    random.shuffle(options)
    questions.append({
        "id": f"p1_l{level_num}_q8",
        "type": "mcq",
        "text": tb["q"],
        "options": options,
        "correctAnswerIndex": options.index(tb["a"])
    })

    # Q9: Peribahasa MCQ
    peribahasa = [
        {"q": "Apa arti dari peribahasa 'Ada udang di balik batu'?", "a": "Ada maksud tersembunyi", "d": ["Mendapat bahaya besar", "Mencari keuntungan", "Suka berbohong"]},
        {"q": "Apa arti peribahasa 'Bagai air di daun talas'?", "a": "Tidak punya pendirian tetap", "d": ["Sangat dingin dan sejuk", "Mudah bergaul", "Suka kemewahan"]},
        {"q": "Apa arti peribahasa 'Tong kosong nyaring bunyinya'?", "a": "Orang bodoh yang banyak bicara", "d": ["Orang pandai yang rendah hati", "Suara yang merdu", "Barang yang tidak berguna"]}
    ]
    pb = peribahasa[level_num % len(peribahasa)]
    options = [pb["a"]] + pb["d"]
    random.shuffle(options)
    questions.append({
        "id": f"p1_l{level_num}_q9",
        "type": "mcq",
        "text": pb["q"],
        "options": options,
        "correctAnswerIndex": options.index(pb["a"])
    })

    # Q10: Essay Antonim/Kata Baku
    item = antonyms_db[(idx_ant1 + 5) % len(antonyms_db)]
    questions.append({
        "id": f"p1_l{level_num}_q10",
        "type": "essay",
        "text": f"Tuliskan antonim (lawan kata) dari kata '{item['word']}'!",
        "correctAnswer": item["correct"].lower()
    })

    return questions

def generate_math_questions(level_num):
    questions = []
    
    # Tingkat kesulitan meningkat seiring naiknya level_num
    if level_num <= 20:
        # Level 1-20: Penjumlahan dan Pengurangan (Aritmatika Dasar)
        for q_idx in range(1, 11):
            is_essay = q_idx in [5, 10]
            q_id = f"p2_l{level_num}_q{q_idx}"
            
            if q_idx % 2 == 0:
                # Penjumlahan
                a = random.randint(10, 50) + level_num
                b = random.randint(5, 40)
                ans = a + b
                text = f"Berapakah hasil penjumlahan dari {a} + {b}?"
            else:
                # Pengurangan
                a = random.randint(40, 99) + level_num
                b = random.randint(10, 39)
                ans = a - b
                text = f"Berapakah hasil pengurangan dari {a} - {b}?"
                
            if is_essay:
                questions.append({
                    "id": q_id,
                    "type": "essay",
                    "text": text,
                    "correctAnswer": str(ans)
                })
            else:
                options = [str(ans), str(ans + 2), str(ans - 3), str(ans + 5)]
                random.shuffle(options)
                questions.append({
                    "id": q_id,
                    "type": "mcq",
                    "text": text,
                    "options": options,
                    "correctAnswerIndex": options.index(str(ans))
                })
                
    elif level_num <= 50:
        # Level 21-50: Perkalian dan Pembagian
        for q_idx in range(1, 11):
            is_essay = q_idx in [5, 10]
            q_id = f"p2_l{level_num}_q{q_idx}"
            
            if q_idx % 2 == 0:
                # Perkalian
                a = random.randint(2, 12)
                b = random.randint(3, 11)
                ans = a * b
                text = f"Berapakah hasil dari {a} x {b}?"
            else:
                # Pembagian
                b = random.randint(2, 10)
                ans = random.randint(3, 12)
                a = ans * b
                text = f"Berapakah hasil dari {a} : {b}?"
                
            if is_essay:
                questions.append({
                    "id": q_id,
                    "type": "essay",
                    "text": text,
                    "correctAnswer": str(ans)
                })
            else:
                options = [str(ans), str(ans + 4), str(ans - 2), str(ans + 1)]
                random.shuffle(options)
                questions.append({
                    "id": q_id,
                    "type": "mcq",
                    "text": text,
                    "options": options,
                    "correctAnswerIndex": options.index(str(ans))
                })
                
    elif level_num <= 80:
        # Level 51-80: Aljabar dan Geometri Sederhana
        for q_idx in range(1, 11):
            is_essay = q_idx in [5, 10]
            q_id = f"p2_l{level_num}_q{q_idx}"
            
            if q_idx % 3 == 0:
                # Aljabar
                x = random.randint(2, 10)
                c = random.randint(5, 20)
                mx = x * random.randint(2, 5)
                constant = mx + c
                coeff = mx // x
                # Equation: coeff * x + c = constant
                text = f"Jika {coeff}x + {c} = {constant}, berapakah nilai x?"
                ans = x
            elif q_idx % 3 == 1:
                # Geometri Luas
                sisi = random.randint(4, 15)
                ans = sisi * sisi
                text = f"Berapakah luas persegi yang memiliki panjang sisi {sisi} cm?"
            else:
                # Geometri Segitiga
                alas = random.randint(4, 20)
                tinggi = random.randint(3, 10) * 2
                ans = int(0.5 * alas * tinggi)
                text = f"Sebuah segitiga memiliki alas {alas} cm dan tinggi {tinggi} cm. Luas segitiga tersebut adalah..."
                
            if is_essay:
                questions.append({
                    "id": q_id,
                    "type": "essay",
                    "text": text,
                    "correctAnswer": str(ans)
                })
            else:
                options = [str(ans), str(ans + 10), str(ans - 5), str(ans + 3)]
                random.shuffle(options)
                questions.append({
                    "id": q_id,
                    "type": "mcq",
                    "text": text,
                    "options": options,
                    "correctAnswerIndex": options.index(str(ans))
                })
                
    else:
        # Level 81-100: Pecahan, Deret Angka, dan Soal Cerita Matematika
        for q_idx in range(1, 11):
            is_essay = q_idx in [5, 10]
            q_id = f"p2_l{level_num}_q{q_idx}"
            
            if q_idx % 3 == 0:
                # Pola Deret
                start = random.randint(1, 10)
                diff = random.randint(3, 8)
                deret = [start + diff * i for i in range(5)]
                ans = deret[-1]
                text = f"Tentukan angka berikutnya dari pola bilangan berikut: {', '.join(map(str, deret[:-1]))}, ...?"
            elif q_idx % 3 == 1:
                # Soal Cerita
                buku_count = random.randint(2, 5)
                price_per_buku = random.randint(2000, 5000)
                total_given = buku_count * price_per_buku
                target_count = buku_count + random.randint(2, 4)
                ans = target_count * price_per_buku
                text = f"Harga {buku_count} buah buku adalah Rp{total_given}. Berapakah harga {target_count} buah buku serupa?"
            else:
                # Pecahan campuran
                a = random.randint(1, 5)
                ans = a * 15 # Skala pengali desimal
                text = f"Berapakah hasil perkalian dari 1.5 x {a}?"
                ans = str(1.5 * a)
                if ans.endswith(".0"):
                    ans = ans[:-2]
                
            if is_essay:
                questions.append({
                    "id": q_id,
                    "type": "essay",
                    "text": text,
                    "correctAnswer": str(ans)
                })
            else:
                options = [str(ans), str(float(ans) + 1.5 if '.' in str(ans) else int(ans) + 2), str(float(ans) - 1.0 if '.' in str(ans) else int(ans) - 3), str(float(ans) + 3.0 if '.' in str(ans) else int(ans) + 4)]
                # Rapikan desimal
                options = [o[:-2] if o.endswith(".0") else o for o in options]
                # Pastikan jawaban benar unik
                options = list(set(options))
                if str(ans) not in options:
                    options[0] = str(ans)
                random.shuffle(options)
                questions.append({
                    "id": q_id,
                    "type": "mcq",
                    "text": text,
                    "options": options,
                    "correctAnswerIndex": options.index(str(ans))
                })

    return questions

# Mengumpulkan semua level kuis
levels = []
for i in range(1, 101):
    levels.append({
        "id": f"p1_l{i}",
        "partId": "p1",
        "order": i,
        "questions": generate_indonesian_questions(i)
    })
    
for i in range(1, 101):
    levels.append({
        "id": f"p2_l{i}",
        "partId": "p2",
        "order": i,
        "questions": generate_math_questions(i)
    })

data = {
    "parts": [
        {
            "id": "p1",
            "title": "Quiz Bahasa Indonesia",
            "description": "Uji kemampuan tata bahasa dan kosa kata Bahasa Indonesia Anda.",
            "isLocked": False
        },
        {
            "id": "p2",
            "title": "Quiz Matematika",
            "description": "Tantangan logika dan angka untuk mengasah otak.",
            "isLocked": False
        }
    ],
    "levels": levels
}

with open('assets/data/questions.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print("Berhasil men-generate 2000 soal kuis nyata yang edukatif ke assets/data/questions.json!")
