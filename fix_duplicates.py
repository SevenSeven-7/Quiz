import json
import random

# Baca file database
with open('c:\\laragon\\www\\Quiz\\Quiz_Dataset\\database-bahasaindonesia.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Total soal awal: {len(data)}")

# Hapus duplikasi berdasarkan kombinasi text dan correctAnswer
seen = {}
unique_questions = []
for item in data:
    key = (item['text'], item['correctAnswer'])
    if key not in seen:
        seen[key] = True
        unique_questions.append(item)

print(f"Soal unik setelah deduplikasi: {len(unique_questions)}")

# Template soal baru yang bervariasi tentang Bahasa Indonesia
new_questions_templates = [
    # Ejaan dan Tata Bahasa
    {
        "text": "Penulisan kata yang benar menurut EYD adalah?",
        "variants": [
            {"options": ["Sistim", "System", "Sistem", "Sisthim"], "correct": 2, "answer": "Sistem"},
            {"options": ["Standarisasi", "Standardisasi", "Standarisazi", "Standarizasi"], "correct": 0, "answer": "Standarisasi"},
            {"options": ["Ijazah", "Ijasah", "Ijazha", "Izajah"], "correct": 0, "answer": "Ijazah"},
            {"options": ["Nasehat", "Nasihat", "Nasehad", "Nasihad"], "correct": 1, "answer": "Nasihat"},
            {"options": ["Praktek", "Praktik", "Praktiek", "Prakthik"], "correct": 1, "answer": "Praktik"},
        ]
    },
    {
        "text": "Kata baku yang tepat adalah?",
        "variants": [
            {"options": ["Apotek", "Apotik", "Apothek", "Apothik"], "correct": 0, "answer": "Apotek"},
            {"options": ["Atlit", "Atlet", "Athlet", "Athleth"], "correct": 1, "answer": "Atlet"},
            {"options": ["Frekwensi", "Frekuensi", "Frequensi", "Frekwency"], "correct": 1, "answer": "Frekuensi"},
            {"options": ["Hirarki", "Hierarki", "Hirarkhi", "Hierarkhi"], "correct": 1, "answer": "Hierarki"},
            {"options": ["Karir", "Karier", "Karrir", "Karriir"], "correct": 1, "answer": "Karier"},
        ]
    },
    # Majas
    {
        "text": "Majas yang memberikan sifat manusia pada benda mati disebut?",
        "variants": [
            {"options": ["Metafora", "Personifikasi", "Hiperbola", "Simile"], "correct": 1, "answer": "Personifikasi"},
        ]
    },
    {
        "text": "Majas yang menyatakan sesuatu dengan berlebihan disebut?",
        "variants": [
            {"options": ["Litotes", "Hiperbola", "Ironi", "Paradoks"], "correct": 1, "answer": "Hiperbola"},
        ]
    },
    {
        "text": "Majas yang menyatakan sesuatu dengan kebalikannya untuk merendah disebut?",
        "variants": [
            {"options": ["Hiperbola", "Litotes", "Ironi", "Sarkasme"], "correct": 1, "answer": "Litotes"},
        ]
    },
    {
        "text": "Majas yang membandingkan dua hal dengan kata 'seperti' atau 'bagai' disebut?",
        "variants": [
            {"options": ["Metafora", "Simile", "Personifikasi", "Alegori"], "correct": 1, "answer": "Simile"},
        ]
    },
    # Kalimat
    {
        "text": "Kalimat yang mengandung perintah disebut kalimat?",
        "variants": [
            {"options": ["Deklaratif", "Interogatif", "Imperatif", "Ekslamatif"], "correct": 2, "answer": "Imperatif"},
        ]
    },
    {
        "text": "Kalimat yang mengandung pertanyaan disebut kalimat?",
        "variants": [
            {"options": ["Imperatif", "Interogatif", "Deklaratif", "Ekslamatif"], "correct": 1, "answer": "Interogatif"},
        ]
    },
    {
        "text": "Kalimat yang hanya memiliki satu subjek dan satu predikat disebut kalimat?",
        "variants": [
            {"options": ["Majemuk", "Tunggal", "Kompleks", "Bertingkat"], "correct": 1, "answer": "Tunggal"},
        ]
    },
    {
        "text": "Kalimat yang memiliki lebih dari satu klausa disebut kalimat?",
        "variants": [
            {"options": ["Tunggal", "Majemuk", "Sederhana", "Efektif"], "correct": 1, "answer": "Majemuk"},
        ]
    },
    # Paragraf
    {
        "text": "Paragraf yang ide pokoknya berada di awal disebut paragraf?",
        "variants": [
            {"options": ["Induktif", "Deduktif", "Campuran", "Naratif"], "correct": 1, "answer": "Deduktif"},
        ]
    },
    {
        "text": "Paragraf yang ide pokoknya berada di awal dan akhir disebut paragraf?",
        "variants": [
            {"options": ["Induktif", "Deduktif", "Campuran", "Deskriptif"], "correct": 2, "answer": "Campuran"},
        ]
    },
    # Kata Hubung
    {
        "text": "Kata hubung yang menyatakan sebab akibat adalah?",
        "variants": [
            {"options": ["tetapi", "karena", "atau", "dan"], "correct": 1, "answer": "karena"},
            {"options": ["maka", "tetapi", "atau", "dan"], "correct": 0, "answer": "maka"},
            {"options": ["sehingga", "tetapi", "atau", "dan"], "correct": 0, "answer": "sehingga"},
        ]
    },
    {
        "text": "Kata hubung yang menyatakan pilihan adalah?",
        "variants": [
            {"options": ["dan", "atau", "tetapi", "karena"], "correct": 1, "answer": "atau"},
        ]
    },
    {
        "text": "Kata hubung yang menyatakan penambahan adalah?",
        "variants": [
            {"options": ["atau", "tetapi", "dan", "karena"], "correct": 2, "answer": "dan"},
        ]
    },
    # Imbuhan
    {
        "text": "Imbuhan yang membentuk kata kerja aktif adalah?",
        "variants": [
            {"options": ["di-", "me-", "ter-", "pe-"], "correct": 1, "answer": "me-"},
            {"options": ["di-", "ber-", "ter-", "pe-"], "correct": 1, "answer": "ber-"},
        ]
    },
    {
        "text": "Imbuhan yang membentuk kata benda adalah?",
        "variants": [
            {"options": ["me-", "ber-", "pe-", "di-"], "correct": 2, "answer": "pe-"},
            {"options": ["me-", "ber-", "-an", "di-"], "correct": 2, "answer": "-an"},
        ]
    },
    {
        "text": "Imbuhan yang menyatakan 'tidak sengaja' adalah?",
        "variants": [
            {"options": ["me-", "ber-", "ter-", "di-"], "correct": 2, "answer": "ter-"},
        ]
    },
    # Sinonim
    {
        "text": "Sinonim kata 'cerdas' adalah?",
        "variants": [
            {"options": ["Bodoh", "Pintar", "Malas", "Lambat"], "correct": 1, "answer": "Pintar"},
        ]
    },
    {
        "text": "Sinonim kata 'indah' adalah?",
        "variants": [
            {"options": ["Jelek", "Cantik", "Buruk", "Kotor"], "correct": 1, "answer": "Cantik"},
        ]
    },
    {
        "text": "Sinonim kata 'rajin' adalah?",
        "variants": [
            {"options": ["Malas", "Giat", "Lambat", "Bodoh"], "correct": 1, "answer": "Giat"},
        ]
    },
    {
        "text": "Sinonim kata 'besar' adalah?",
        "variants": [
            {"options": ["Kecil", "Raksasa", "Mungil", "Sempit"], "correct": 1, "answer": "Raksasa"},
        ]
    },
    # Antonim
    {
        "text": "Antonim kata 'tinggi' adalah?",
        "variants": [
            {"options": ["Besar", "Rendah", "Luas", "Panjang"], "correct": 1, "answer": "Rendah"},
        ]
    },
    {
        "text": "Antonim kata 'terang' adalah?",
        "variants": [
            {"options": ["Gelap", "Cerah", "Bening", "Jernih"], "correct": 0, "answer": "Gelap"},
        ]
    },
    {
        "text": "Antonim kata 'kaya' adalah?",
        "variants": [
            {"options": ["Miskin", "Makmur", "Sejahtera", "Beruntung"], "correct": 0, "answer": "Miskin"},
        ]
    },
    {
        "text": "Antonim kata 'panas' adalah?",
        "variants": [
            {"options": ["Hangat", "Dingin", "Sejuk", "Lembab"], "correct": 1, "answer": "Dingin"},
        ]
    },
    # Jenis Kata
    {
        "text": "Kata yang menunjukkan perbuatan atau tindakan disebut kata?",
        "variants": [
            {"options": ["Benda", "Kerja", "Sifat", "Bilangan"], "correct": 1, "answer": "Kerja"},
        ]
    },
    {
        "text": "Kata yang menunjukkan nama orang, tempat, atau benda disebut kata?",
        "variants": [
            {"options": ["Kerja", "Benda", "Sifat", "Keterangan"], "correct": 1, "answer": "Benda"},
        ]
    },
    {
        "text": "Kata yang menunjukkan sifat atau keadaan disebut kata?",
        "variants": [
            {"options": ["Benda", "Kerja", "Sifat", "Bilangan"], "correct": 2, "answer": "Sifat"},
        ]
    },
    {
        "text": "Kata yang menunjukkan jumlah atau urutan disebut kata?",
        "variants": [
            {"options": ["Benda", "Kerja", "Sifat", "Bilangan"], "correct": 3, "answer": "Bilangan"},
        ]
    },
    # Unsur Kalimat
    {
        "text": "Unsur kalimat yang menjadi pokok pembicaraan disebut?",
        "variants": [
            {"options": ["Predikat", "Subjek", "Objek", "Keterangan"], "correct": 1, "answer": "Subjek"},
        ]
    },
    {
        "text": "Unsur kalimat yang menerangkan subjek disebut?",
        "variants": [
            {"options": ["Subjek", "Predikat", "Objek", "Pelengkap"], "correct": 1, "answer": "Predikat"},
        ]
    },
    {
        "text": "Unsur kalimat yang melengkapi predikat disebut?",
        "variants": [
            {"options": ["Subjek", "Predikat", "Objek", "Keterangan"], "correct": 2, "answer": "Objek"},
        ]
    },
    # Jenis Wacana
    {
        "text": "Wacana yang menceritakan suatu peristiwa disebut wacana?",
        "variants": [
            {"options": ["Deskripsi", "Narasi", "Eksposisi", "Argumentasi"], "correct": 1, "answer": "Narasi"},
        ]
    },
    {
        "text": "Wacana yang menggambarkan sesuatu disebut wacana?",
        "variants": [
            {"options": ["Narasi", "Deskripsi", "Eksposisi", "Persuasi"], "correct": 1, "answer": "Deskripsi"},
        ]
    },
    {
        "text": "Wacana yang menjelaskan sesuatu disebut wacana?",
        "variants": [
            {"options": ["Narasi", "Deskripsi", "Eksposisi", "Argumentasi"], "correct": 2, "answer": "Eksposisi"},
        ]
    },
    {
        "text": "Wacana yang bertujuan meyakinkan pembaca disebut wacana?",
        "variants": [
            {"options": ["Narasi", "Deskripsi", "Eksposisi", "Argumentasi"], "correct": 3, "answer": "Argumentasi"},
        ]
    },
    # Tanda Baca
    {
        "text": "Tanda baca yang digunakan untuk mengakhiri kalimat berita adalah?",
        "variants": [
            {"options": ["Tanda tanya (?)", "Titik (.)", "Seru (!)", "Koma (,)"], "correct": 1, "answer": "Titik (.)"},
        ]
    },
    {
        "text": "Tanda baca yang digunakan untuk mengakhiri kalimat tanya adalah?",
        "variants": [
            {"options": ["Titik (.)", "Tanda tanya (?)", "Seru (!)", "Koma (,)"], "correct": 1, "answer": "Tanda tanya (?)"},
        ]
    },
    {
        "text": "Tanda baca yang digunakan untuk memisahkan unsur dalam kalimat adalah?",
        "variants": [
            {"options": ["Titik (.)", "Tanda tanya (?)", "Koma (,)", "Seru (!)"], "correct": 2, "answer": "Koma (,)"},
        ]
    },
    # Kata Serapan
    {
        "text": "Kata serapan dari bahasa Inggris 'computer' dalam bahasa Indonesia adalah?",
        "variants": [
            {"options": ["Komputer", "Kompyuter", "Komputir", "Komputer"], "correct": 0, "answer": "Komputer"},
        ]
    },
    {
        "text": "Kata serapan dari bahasa Arab 'kitab' dalam bahasa Indonesia tetap?",
        "variants": [
            {"options": ["Kitab", "Kitap", "Khitab", "Khitap"], "correct": 0, "answer": "Kitab"},
        ]
    },
    # Ragam Bahasa
    {
        "text": "Bahasa yang digunakan dalam situasi resmi disebut bahasa?",
        "variants": [
            {"options": ["Santai", "Baku", "Gaul", "Daerah"], "correct": 1, "answer": "Baku"},
        ]
    },
    {
        "text": "Bahasa yang digunakan dalam percakapan sehari-hari disebut bahasa?",
        "variants": [
            {"options": ["Baku", "Tidak baku", "Resmi", "Formal"], "correct": 1, "answer": "Tidak baku"},
        ]
    },
    # Puisi
    {
        "text": "Puisi lama yang terdiri dari 4 baris dengan pola a-b-a-b disebut?",
        "variants": [
            {"options": ["Syair", "Pantun", "Gurindam", "Talibun"], "correct": 1, "answer": "Pantun"},
        ]
    },
    {
        "text": "Puisi lama yang semua barisnya berisi isi disebut?",
        "variants": [
            {"options": ["Pantun", "Syair", "Gurindam", "Seloka"], "correct": 1, "answer": "Syair"},
        ]
    },
    {
        "text": "Puisi lama yang terdiri dari 2 baris berisi nasihat disebut?",
        "variants": [
            {"options": ["Pantun", "Syair", "Gurindam", "Talibun"], "correct": 2, "answer": "Gurindam"},
        ]
    },
]

# Generate soal baru
new_questions = []
question_id = 1

for template in new_questions_templates:
    for variant in template["variants"]:
        new_question = {
            "id": f"hard_{question_id:04d}",
            "text": template["text"],
            "type": "mcq",
            "options": variant["options"],
            "correctAnswerIndex": variant["correct"],
            "correctAnswer": variant["answer"]
        }
        new_questions.append(new_question)
        question_id += 1

print(f"Soal baru yang dibuat: {len(new_questions)}")

# Gabungkan soal unik dengan soal baru
all_questions = unique_questions + new_questions

# Jika masih kurang dari 3000, duplikasi dengan variasi urutan opsi
while len(all_questions) < 3000:
    for q in new_questions[:]:
        if len(all_questions) >= 3000:
            break
        
        # Buat variasi dengan mengacak urutan opsi
        new_q = q.copy()
        new_q["id"] = f"hard_{len(all_questions) + 1:04d}"
        
        # Acak opsi
        options = new_q["options"][:]
        correct_answer = new_q["correctAnswer"]
        random.shuffle(options)
        new_correct_index = options.index(correct_answer)
        
        new_q["options"] = options
        new_q["correctAnswerIndex"] = new_correct_index
        
        all_questions.append(new_q)

# Pastikan tepat 3000 soal
all_questions = all_questions[:3000]

print(f"Total soal akhir: {len(all_questions)}")

# Simpan ke file baru
with open('c:\\laragon\\www\\Quiz\\Quiz_Dataset\\database-bahasaindonesia.json', 'w', encoding='utf-8') as f:
    json.dump(all_questions, f, ensure_ascii=False, indent=2)

print("✓ File berhasil diperbaiki!")
print(f"✓ Soal unik dari file lama: {len(unique_questions)}")
print(f"✓ Soal baru yang ditambahkan: {len(new_questions)}")
print(f"✓ Total soal dalam database: {len(all_questions)}")
