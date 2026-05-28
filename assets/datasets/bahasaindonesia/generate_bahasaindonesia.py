import json
import random

questions_list = []
q_id = 1

def add_q(text, correct, options):
    global q_id
    if text in [q['text'] for q in questions_list]:
        return
        
    opts = options.copy()
    if correct not in opts:
        opts.append(correct)
        
    unique_opts = []
    for o in opts:
        if o not in unique_opts:
            unique_opts.append(o)
    opts = unique_opts
    
    while len(opts) < 4:
        opts.append("Opsi jawaban salah " + str(random.randint(1,1000)))
    
    if len(opts) > 4:
        opts.remove(correct)
        opts = random.sample(opts, 3)
        opts.append(correct)

    random.shuffle(opts)
    
    q = {
        "text": text,
        "correctAnswer": correct,
        "options": opts,
        "type": "multiple_choice",
        "correctAnswerIndex": opts.index(correct)
    }
    questions_list.append(q)

# 1. Antonim
antonim = [
    ("Asli", "Palsu"), ("Cepat", "Lambat"), ("Tinggi", "Rendah"), ("Jauh", "Dekat"), 
    ("Kuat", "Lemah"), ("Terang", "Gelap"), ("Pro", "Kontra"), ("Mayoritas", "Minoritas"),
    ("Fiktif", "Nyata"), ("Maya", "Nyata"), ("Apriori", "Aposteriori"), ("Deduksi", "Induksi"),
    ("Vertikal", "Horizontal"), ("Imigrasi", "Emigrasi"), ("Statis", "Dinamis"), 
    ("Optimis", "Pesimis"), ("Ekstrovert", "Introvert"), ("Mayor", "Minor"), 
    ("Progresif", "Regresif"), ("Konkret", "Abstrak"), ("Universal", "Parsial"),
    ("Sporadis", "Rutin"), ("Nisbi", "Mutlak"), ("Tradisional", "Modern"),
    ("Nomaden", "Menetap"), ("Antipati", "Simpati"), ("Kolektif", "Individual"),
    ("Aktual", "Basi/Kedaluwarsa"), ("Absolut", "Relatif"), ("Kohesi", "Adhesi"), ("Insidental", "Rutin"),
    ("Amatir", "Profesional"), ("Epilog", "Prolog"), ("Destruktif", "Konstruktif"),
    ("Revolusi", "Evolusi"), ("Mortal", "Immortal/Abadi"), ("Defisit", "Surplus"),
    ("Monoton", "Bervariasi"), ("Eksplisit", "Implisit"), ("Plural", "Tunggal"),
    ("Ortodoks", "Modern"), ("Apatis", "Peduli"), ("Eksterior", "Interior"),
    ("Paternalisme", "Maternalisme"), ("Sentrifugal", "Sentripetal"), ("Otoriter", "Demokratis")
]
for kata, lawan in antonim:
    others = random.sample([a[1] for a in antonim if a[1] != lawan], 3)
    add_q(f"Teka-teki Antonim: Lawan kata dari '{kata}' yang paling tepat adalah...", lawan, others)
    others2 = random.sample([a[0] for a in antonim if a[0] != kata], 3)
    add_q(f"Logika Kosakata: Antonim dari kata '{lawan}' adalah...", kata, others2)

# 2. Sinonim
sinonim = [
    ("Evokasi", "Penggugah rasa"), ("Bogel", "Kerdil"), ("Agitasi", "Hasutan"), 
    ("Anomali", "Penyimpangan/Kelainan"), ("Tentatif", "Belum pasti"), ("Afirmasi", "Penegasan"), 
    ("Dispensasi", "Pengecualian"), ("Pandemi", "Wabah global"), ("Paradoks", "Bertentangan/Lawan asas"), 
    ("Paradigma", "Kerangka berpikir"), ("Kompilasi", "Kumpulan"), ("Implisit", "Tersirat"), 
    ("Eksplisit", "Tersurat"), ("Sinkron", "Sesuai/Selaras"), ("Komprehensif", "Menyeluruh"), 
    ("Signifikan", "Berarti/Penting"), ("Esensial", "Mendasar"), ("Pragmatis", "Praktis"),
    ("Baku", "Standar"), ("Akselerasi", "Percepatan"), ("Akurat", "Seksama/Tepat"),
    ("Sinergi", "Kerja sama"), ("Orientasi", "Peninjauan"), ("Insting", "Naluri"),
    ("Defleksi", "Penyimpangan"), ("Injeksi", "Suntikan"), ("Tendensi", "Kecenderungan"),
    ("Kontradiksi", "Pertentangan"), ("Distorsi", "Pemutarbalikan fakta"), ("Anekdot", "Cerita lucu singkat"),
    ("Bursa", "Pusat perdagangan/Pasar"), ("Dehidrasi", "Kekurangan cairan"), ("Ekspansi", "Perluasan wilayah"),
    ("Fiksi", "Khayalan/Rekaan"), ("Hibrida", "Campuran/Hasil silang"), ("Insentif", "Bonus/Tambahan upah"),
    ("Konsesi", "Pemberian izin/Hak"), ("Legitimasi", "Pengesahan/Keabsahan"), ("Marjinal", "Tepi/Pinggiran")
]
for kata, sama in sinonim:
    others = random.sample([s[1] for s in sinonim if s[1] != sama], 3)
    add_q(f"Teka-teki Sinonim: Persamaan makna dari kata '{kata}' adalah...", sama, others)
    others2 = random.sample([s[0] for s in sinonim if s[0] != kata], 3)
    add_q(f"Logika Kosakata: Kata yang memiliki makna serupa dengan '{sama}' yaitu...", kata, others2)

# 3. Analogi / Logika Bahasa
analogi = [
    ("Mobil", "Bensin", "Pelari", "Makanan"),
    ("Guru", "Sekolah", "Dokter", "Rumah Sakit"),
    ("Ikan", "Air", "Burung", "Udara"),
    ("Buku", "Kertas", "Meja", "Kayu"),
    ("Mata", "Melihat", "Telinga", "Mendengar"),
    ("Haus", "Minum", "Lapar", "Makan"),
    ("Siang", "Matahari", "Malam", "Bulan"),
    ("Ulat", "Sutra", "Lebah", "Madu"),
    ("Kamera", "Foto", "Kuas", "Lukisan"),
    ("Pena", "Tinta", "Pensil", "Grafit"),
    ("Tukang Kayu", "Gergaji", "Petani", "Cangkul"),
    ("Padi", "Beras", "Gandum", "Roti"),
    ("Pesawat", "Avtur", "Kereta Api", "Batu Bara/Listrik"),
    ("Rumput", "Hijau", "Darah", "Merah"),
    ("Gembok", "Kunci", "Masalah", "Solusi"),
    ("Kapal", "Nahkoda", "Pesawat", "Pilot"),
    ("Hidung", "Mencium", "Kulit", "Meraba")
]
for a1, b1, a2, b2 in analogi:
    add_q(f"Logika Analogi: {a1} berhubungan dengan {b1}, sebagaimana {a2} berhubungan dengan...", b2, 
          [x[3] for x in analogi if x[3] != b2])
    add_q(f"Analogi Bahasa: {a1} : {b1} = {a2} : ...", b2, 
          [x[3] for x in analogi if x[3] != b2])

# 4. Cerita Logika / Urutan
names = ["Andi", "Budi", "Cici", "Dedi", "Eka", "Fani", "Gani", "Hadi", "Iwan", "Joko"]
for _ in range(120):
    n1, n2, n3, n4 = random.sample(names, 4)
    add_q(f"Cerita Logika: Jika {n1} lebih tinggi dari {n2}, {n2} lebih tinggi dari {n3}, dan {n3} lebih tinggi dari {n4}. Siapakah yang berpostur paling tinggi?", n1, [n2, n3, n4])
    add_q(f"Cerita Logika: Jika {n1} lebih tinggi dari {n2}, {n2} lebih tinggi dari {n3}, dan {n3} lebih tinggi dari {n4}. Siapakah yang berpostur paling pendek?", n4, [n1, n2, n3])
    add_q(f"Logika Usia: {n1} lebih tua dari {n2}. {n3} lebih muda dari {n2}. Siapa yang usianya kemungkinan berada di tengah-tengah?", n2, [n1, n3, "Tidak dapat ditentukan pasti"])
    add_q(f"Logika Perlombaan: Dalam sebuah maraton, {n1} berlari mendahului {n2}, tetapi {n1} baru saja disalip oleh {n3}. Siapa yang paling belakang dari ketiganya saat ini?", n2, [n1, n3, "Berada sejajar"])

# 5. Silogisme / Logika Deduktif
silogisme_x = ["mahasiswa", "karyawan", "guru", "dokter", "atlet", "ilmuwan", "penulis", "programmer"]
silogisme_y = ["rajin belajar", "bekerja keras", "membaca buku", "berkacamata", "memakai seragam", "berpikir kritis"]
silogisme_z = ["mendapat nilai A", "naik jabatan", "berwawasan luas", "tampak pintar", "terlihat rapi", "menjadi sukses"]

for _ in range(100):
    x = random.choice(silogisme_x)
    y = random.choice(silogisme_y)
    z = random.choice(silogisme_z)
    
    add_q(f"Logika Deduktif: Semua {x} {y}. Sebagian {x} {z}. Kesimpulan yang tepat dari premis tersebut adalah...",
          f"Sebagian {x} yang {y}, juga {z}",
          [f"Semua {x} yang {z} pasti tidak {y}", f"Tidak ada {x} yang {y} dan {z}", f"Semua {x} pasti {z}"])
    
    add_q(f"Silogisme: Semua {x} dituntut untuk {y}. Seorang pria bernama Budi adalah {x} namun ia tidak {y}. Kesimpulannya...",
          f"Budi melanggar tuntutan {x} atau premis tentang Budi keliru",
          [f"Budi adalah teladan {x}", f"Semua {x} ingin menjadi seperti Budi", f"Budi berhak tidak {y}"])

# 6. Teka-Teki Logika Klasik
riddles = [
    ("Cerita Logika: Sebuah pesawat terbang komersial jatuh tepat di garis demarkasi perbatasan negara X dan Y. Secara hukum internasional, di manakah mereka akan menguburkan para penumpang yang SELAMAT?", "Korban yang selamat tentu tidak dikubur", ["Di wilayah negara X", "Di wilayah negara Y", "Tepat di garis perbatasan"]),
    ("Cerita Logika: Ibu Ani sedang mengandung, ia juga memiliki 3 anak. Anak pertama bernama Eka, anak kedua bernama Eki. Siapa nama anak ketiganya?", "Ani", ["Eko", "Eku", "Ayahnya"]),
    ("Teka-teki Logika: Jika kamu sedang ikut lomba maraton dan secara mengejutkan kamu berhasil menyalip orang di posisi kedua, maka posisi berapakah kamu sekarang?", "Posisi kedua", ["Posisi pertama", "Posisi ketiga", "Posisi terakhir"]),
    ("Logika Waktu: Kalau Januari punya 31 hari, lalu bulan apa saja yang memiliki 28 hari di kalender Masehi?", "Semua bulan memiliki tanggal 28", ["Hanya bulan Februari", "Januari dan Februari", "Tahun kabisat saja"]),
    ("Teka-teki Abstrak: Apa yang selalu dijanjikan datang namun pada kenyataannya tidak pernah tiba saat kita menunggunya?", "Hari esok", ["Hari ini", "Waktu yang berlalu", "Tahun depan"]),
    ("Cerita Logika: Jika 5 mesin pemotong butuh 5 menit untuk memotong 5 papan, berapa menit yang dibutuhkan oleh 100 mesin untuk memotong 100 papan?", "5 menit", ["100 menit", "1 menit", "500 menit"]),
    ("Teka-teki Ruang: Apa yang bisa kamu pegang dengan mantap menggunakan tangan kananmu, tetapi mustahil dipegang oleh tangan kirimu sendiri?", "Siku tangan kirimu", ["Siku tangan kananmu", "Telinga kirimu", "Bahu kananmu"]),
    ("Logika Ruang: Semakin banyak galian yang kamu ambil dari padanya, ia justru akan menjadi semakin besar ukurannya. Benda apakah itu?", "Lubang", ["Gunung pasir", "Tumpukan sampah", "Bukit buatan"]),
    ("Teka-teki: Jika diucapkan atau disebut namanya, eksistensi hal ini akan segera musnah atau menghilang seketika. Apakah itu?", "Kesunyian / Keheningan", ["Bayangan", "Kegelapan", "Angin lewat"]),
    ("Teka-teki: Ayah Maryam memiliki lima anak: 1. Nana, 2. Nene, 3. Nini, 4. Nono. Siapakah nama anak yang kelima?", "Maryam", ["Nunu", "Nana Junior", "Tidak ada"]),
    ("Cerita Logika: Pak Joko berjalan menembus hujan deras tanpa membawa payung atau topi. Namun, tidak sehelai pun rambut di kepalanya basah. Mengapa?", "Karena Pak Joko botak", ["Karena hujannya kecil", "Karena dia berlari sangat cepat", "Karena memakai jas hujan penuh"])
]
for q, a, opts in riddles:
    add_q(q, a, opts)

# Target exactly 500
random.shuffle(questions_list)
if len(questions_list) > 500:
    questions_list = questions_list[:500]

for i, q in enumerate(questions_list):
    q['id'] = f"bahasaindonesia_{i+1}"

db_path = 'c:/laragon/www/Quiz/assets/datasets/bahasaindonesia/database-bahasaindonesia.json'
with open(db_path, 'w', encoding='utf-8') as f:
    json.dump(questions_list, f, indent=2, ensure_ascii=False)

print(f"Generated EXACTLY {len(questions_list)} unique questions and saved to {db_path}.")
