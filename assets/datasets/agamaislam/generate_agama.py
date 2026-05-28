import json
import random
import os

questions = set()
questions_list = []
q_id = 1

def add_q(text, correct, options):
    global q_id
    
    if text in [q['text'] for q in questions_list]:
        return # Skip identical text
        
    opts = options.copy()
    if correct not in opts:
        opts.append(correct)
        
    # unique opts
    unique_opts = []
    for o in opts:
        if o not in unique_opts:
            unique_opts.append(o)
    opts = unique_opts
    
    while len(opts) < 4:
        opts.append("Opsi lain " + str(random.randint(1,1000)))
    
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

# 1. Malaikat dan Tugas
malaikat = [
    ("Jibril", "menyampaikan wahyu kepada nabi dan rasul"),
    ("Mikail", "membagi rezeki dan menurunkan hujan"),
    ("Israfil", "meniup sangkakala pada hari kiamat"),
    ("Izrail", "mencabut nyawa makhluk hidup"),
    ("Munkar", "menanyai amal perbuatan manusia di alam kubur"),
    ("Nakir", "menanyai manusia di alam kubur bersama Munkar"),
    ("Raqib", "mencatat segala amal kebaikan manusia"),
    ("Atid", "mencatat segala amal keburukan manusia"),
    ("Malik", "menjaga pintu neraka"),
    ("Ridwan", "menjaga pintu surga")
]
malaikat_names = [m[0] for m in malaikat]
for m, t in malaikat:
    add_q(f"Malaikat yang memiliki tugas {t} adalah malaikat...", m, random.sample(malaikat_names, 4))
    add_q(f"Siapakah malaikat yang diutus Allah SWT untuk {t}?", m, random.sample(malaikat_names, 4))
    
    add_q(f"Tugas utama dari malaikat {m} adalah...", t, [x[1] for x in malaikat])
    add_q(f"Malaikat {m} diberikan tugas oleh Allah SWT untuk...", t, [x[1] for x in malaikat])

# 2. Rukun Islam
rukun_islam = [
    (1, "Mengucapkan dua kalimat syahadat"),
    (2, "Mendirikan shalat"),
    (3, "Menunaikan zakat"),
    (4, "Berpuasa di bulan Ramadhan"),
    (5, "Menunaikan ibadah haji bagi yang mampu")
]
ri_texts = [r[1] for r in rukun_islam]
for r, t in rukun_islam:
    add_q(f"Rukun Islam yang ke-{r} adalah...", t, ri_texts)
    add_q(f"Menurut syariat, rukun Islam yang berada pada urutan ke-{r} adalah...", t, ri_texts)
    add_q(f"{t} merupakan rukun Islam yang ke-...", str(r), ["1", "2", "3", "4", "5"])
    add_q(f"Kewajiban '{t}' tergolong dalam rukun Islam yang ke-...", str(r), ["1", "2", "3", "4", "5"])

# 3. Rukun Iman
rukun_iman = [
    (1, "Iman kepada Allah SWT"),
    (2, "Iman kepada para Malaikat Allah"),
    (3, "Iman kepada Kitab-kitab Allah"),
    (4, "Iman kepada para Rasul Allah"),
    (5, "Iman kepada Hari Kiamat"),
    (6, "Iman kepada Qada dan Qadar (Takdir)")
]
rm_texts = [r[1] for r in rukun_iman]
for r, t in rukun_iman:
    add_q(f"Rukun Iman yang ke-{r} adalah...", t, rm_texts)
    add_q(f"Berdasarkan aqidah, rukun Iman ke-{r} adalah...", t, rm_texts)
    add_q(f"{t} adalah bagian dari Rukun Iman yang ke-...", str(r), ["1", "2", "3", "4", "5", "6"])
    add_q(f"Keyakinan akan '{t}' menempati urutan ke-... dalam Rukun Iman.", str(r), ["1", "2", "3", "4", "5", "6"])

# 4. Asmaul Husna
asmaul_husna = [
    ("Ar-Rahman", "Yang Maha Pengasih"), ("Ar-Rahim", "Yang Maha Penyayang"), ("Al-Malik", "Yang Maha Merajai"),
    ("Al-Quddus", "Yang Maha Suci"), ("As-Salam", "Yang Maha Memberi Kesejahteraan"), ("Al-Mu'min", "Yang Maha Memberi Keamanan"),
    ("Al-Muhaimin", "Yang Maha Memelihara"), ("Al-Aziz", "Yang Maha Perkasa"), ("Al-Jabbar", "Yang Memiliki Kegagahan"),
    ("Al-Mutakabbir", "Yang Maha Megah"), ("Al-Khaliq", "Yang Maha Pencipta"), ("Al-Bari", "Yang Maha Mengadakan"),
    ("Al-Mushawwir", "Yang Maha Membentuk Rupa"), ("Al-Ghaffar", "Yang Maha Pengampun"), ("Al-Qahhar", "Yang Maha Memaksa"),
    ("Al-Wahhab", "Yang Maha Pemberi Karunia"), ("Ar-Razzaq", "Yang Maha Pemberi Rezeki"), ("Al-Fattah", "Yang Maha Pembuka Rahmat"),
    ("Al-Alim", "Yang Maha Mengetahui"), ("Al-Qabidh", "Yang Maha Menyempitkan"), ("Al-Basit", "Yang Maha Melapangkan"),
    ("Al-Khafidz", "Yang Maha Merendahkan"), ("Ar-Rafi'", "Yang Maha Meninggikan"), ("Al-Mu'izz", "Yang Maha Memuliakan"),
    ("Al-Mudzill", "Yang Maha Menghinakan"), ("As-Sami'", "Yang Maha Mendengar"), ("Al-Bashir", "Yang Maha Melihat"),
    ("Al-Hakam", "Yang Maha Menetapkan Hukum"), ("Al-Adl", "Yang Maha Adil"), ("Al-Latif", "Yang Maha Lembut"),
    ("Al-Khabir", "Yang Maha Waspada/Mengetahui"), ("Al-Halim", "Yang Maha Penyantun"), ("Al-Azhim", "Yang Maha Agung"),
    ("Al-Ghafur", "Yang Maha Pengampun"), ("Asy-Syakur", "Yang Maha Menerima Syukur"), ("Al-Aliy", "Yang Maha Tinggi"),
    ("Al-Kabir", "Yang Maha Besar"), ("Al-Hafizh", "Yang Maha Memelihara"), ("Al-Muqit", "Yang Maha Pemberi Kecukupan"),
    ("Al-Hasib", "Yang Maha Membuat Perhitungan"), ("Al-Jalil", "Yang Maha Luhur"), ("Al-Karim", "Yang Maha Mulia"),
    ("Ar-Raqib", "Yang Maha Mengawasi"), ("Al-Mujib", "Yang Maha Mengabulkan"), ("Al-Wasi'", "Yang Maha Luas"),
    ("Al-Hakim", "Yang Maha Bijaksana"), ("Al-Wadud", "Yang Maha Pecinta"), ("Al-Majid", "Yang Maha Mulia"),
    ("Al-Ba'its", "Yang Maha Membangkitkan"), ("Asy-Syahid", "Yang Maha Menyaksikan"), ("Al-Haqq", "Yang Maha Benar"),
    ("Al-Wakil", "Yang Maha Memelihara/Mewakili"), ("Al-Qawiy", "Yang Maha Kuat"), ("Al-Matin", "Yang Maha Kokoh")
]
ah_names = [a[0] for a in asmaul_husna]
ah_meanings = [a[1] for a in asmaul_husna]
for a, m in asmaul_husna:
    add_q(f"Salah satu Asmaul Husna adalah {a} yang memiliki arti...", m, random.sample(ah_meanings, 4))
    add_q(f"Asmaul Husna yang berarti {m} adalah...", a, random.sample(ah_names, 4))
    add_q(f"Allah SWT memiliki nama yang agung yaitu {a}, maknanya adalah...", m, random.sample(ah_meanings, 4))
    add_q(f"Makna '{m}' terkandung dalam Asmaul Husna...", a, random.sample(ah_names, 4))

# 5. Nabi dan Rasul
nabi = [
    ("Adam", "manusia pertama yang diciptakan", "Bapak Umat Manusia"),
    ("Idris", "orang pertama yang pandai menulis dan membaca", "Nabi yang cerdas"),
    ("Nuh", "membuat bahtera (kapal) besar untuk menyelamatkan umatnya", "Ulul Azmi"),
    ("Hud", "diutus ke kaum 'Ad", "Nabi kaum 'Ad"),
    ("Shalih", "mengeluarkan unta betina dari batu karang", "Nabi kaum Tsamud"),
    ("Ibrahim", "tidak hangus saat dibakar oleh Raja Namrud", "Khalilullah (Kekasih Allah)"),
    ("Luth", "diutus untuk memperbaiki moral kota Sodom", "Keponakan Nabi Ibrahim"),
    ("Ismail", "bersedia disembelih oleh ayahnya sebagai wujud ketaatan", "Anak yang taat"),
    ("Ishaq", "putra Nabi Ibrahim yang saleh", "Bapak dari Ya'qub"),
    ("Ya'qub", "memiliki 12 putra yang kelak menjadi Bani Israil", "Ayah Nabi Yusuf"),
    ("Yusuf", "memiliki ketampanan luar biasa dan ahli menafsirkan mimpi", "Nabi yang sangat tampan"),
    ("Ayyub", "memiliki kesabaran luar biasa saat diuji penyakit menahun", "Simbol kesabaran"),
    ("Syu'aib", "diutus ke kaum Madyan yang suka mencurangi timbangan", "Khatib para Nabi"),
    ("Musa", "membelah lautan dengan tongkatnya", "Kalimullah"),
    ("Harun", "sangat fasih berbicara dan menemani Nabi Musa", "Saudara Nabi Musa"),
    ("Zulkifli", "memiliki sifat sabar dan dermawan yang tinggi", "Pemimpin yang sabar"),
    ("Daud", "mampu melunakkan besi dan memiliki suara merdu", "Penerima Kitab Zabur"),
    ("Sulaiman", "mampu berbicara dengan binatang dan memerintah jin", "Raja yang bijaksana"),
    ("Ilyas", "diutus ke Bani Israil penyembah berhala Ba'al", "Penyelamat Bani Israil"),
    ("Ilyasa", "penerus perjuangan Nabi Ilyas", "Nabi dari Bani Israil"),
    ("Yunus", "bertahan hidup di dalam perut ikan paus", "Dzun Nun"),
    ("Zakariya", "pengasuh Siti Maryam dan baru punya anak di usia tua", "Ayah Nabi Yahya"),
    ("Yahya", "diberi hikmah kecerdasan sejak masih anak-anak", "Nabi yang cerdas"),
    ("Isa", "menyembuhkan orang buta dan menghidupkan orang mati", "Ruhullah"),
    ("Muhammad", "menerima wahyu Al-Qur'an sebagai mukjizat terbesar", "Khatamun Nabiyyin")
]
nabi_names = [n[0] for n in nabi]
nabi_mukjizats = [n[1] for n in nabi]
nabi_gelars = [n[2] for n in nabi]
for n, muk, gelar in nabi:
    add_q(f"Mukjizat atau kisah penting dari Nabi {n} antara lain adalah...", muk, random.sample(nabi_mukjizats, 4))
    add_q(f"Nabi yang dikenal dengan mukjizat/kisah {muk} adalah Nabi...", n, random.sample(nabi_names, 4))
    add_q(f"Nabi {n} sering dikenal dengan sebutan/gelar...", gelar, random.sample(nabi_gelars, 4))
    add_q(f"Gelar atau sebutan {gelar} diberikan kepada Nabi...", n, random.sample(nabi_names, 4))

# 6. Al-Quran Surah
surah = [
    ("Al-Fatihah", "Pembukaan", 7), ("Al-Baqarah", "Sapi Betina", 286), ("Ali 'Imran", "Keluarga Imran", 200),
    ("An-Nisa'", "Wanita", 176), ("Al-Ma'idah", "Jamuan Hidangan", 120), ("Al-An'am", "Binatang Ternak", 165),
    ("Al-A'raf", "Tempat Tertinggi", 206), ("Al-Anfal", "Harta Rampasan Perang", 75), ("At-Taubah", "Pengampunan", 129),
    ("Yunus", "Nabi Yunus", 109), ("Hud", "Nabi Hud", 123), ("Yusuf", "Nabi Yusuf", 111),
    ("Ar-Ra'd", "Guruh", 43), ("Ibrahim", "Nabi Ibrahim", 52), ("Al-Hijr", "Al-Hijr", 99),
    ("An-Nahl", "Lebah", 128), ("Al-Isra'", "Perjalanan Malam", 111), ("Al-Kahf", "Gua", 110),
    ("Maryam", "Siti Maryam", 98), ("Ta-Ha", "Ta-Ha", 135), ("Al-Anbiya'", "Para Nabi", 112),
    ("Al-Hajj", "Haji", 78), ("Al-Mu'minun", "Orang-orang Mukmin", 118), ("An-Nur", "Cahaya", 64),
    ("Al-Furqan", "Pembeda", 77), ("Asy-Syu'ara'", "Para Penyair", 227), ("An-Naml", "Semut", 93),
    ("Al-Qasas", "Kisah-kisah", 88), ("Al-'Ankabut", "Laba-laba", 69), ("Ar-Rum", "Bangsa Romawi", 60),
    ("Luqman", "Keluarga Luqman", 34), ("As-Sajdah", "Sujud", 30), ("Al-Ahzab", "Golongan-golongan", 73),
    ("Saba'", "Kaum Saba'", 54), ("Fatir", "Pencipta", 45), ("Ya-Sin", "Ya-Sin", 83),
    ("Ar-Rahman", "Yang Maha Pemurah", 78), ("Al-Waqi'ah", "Hari Kiamat", 96), ("Al-Mulk", "Kerajaan", 30),
    ("Al-Muzzammil", "Orang yang Berselimut", 20), ("Al-Muddassir", "Orang yang Berkemul", 56), ("Al-Qadr", "Kemuliaan", 5),
    ("Al-Kausar", "Nikmat yang Berlimpah", 3), ("Al-Kafirun", "Orang-orang Kafir", 6), ("An-Nasr", "Pertolongan", 3),
    ("Al-Lahab", "Gejolak Api", 5), ("Al-Ikhlas", "Ikhlas", 4), ("Al-Falaq", "Waktu Subuh", 5),
    ("An-Nas", "Umat Manusia", 6)
]
surah_names = [s[0] for s in surah]
surah_meanings = [s[1] for s in surah]
for s, arti, ayat in surah:
    add_q(f"Surah {s} dalam Al-Qur'an memiliki arti...", arti, random.sample(surah_meanings, 4))
    add_q(f"Surah yang memiliki arti {arti} adalah surah...", s, random.sample(surah_names, 4))

# General Quiz Extenders
quran_q = [
    ("Jumlah total surah dalam Al-Qur'an adalah...", "114 surah", ["114 surah", "144 surah", "30 surah", "6666 surah"]),
    ("Jumlah total juz dalam Al-Qur'an adalah...", "30 juz", ["30 juz", "114 juz", "60 juz", "100 juz"]),
    ("Al-Qur'an diturunkan kepada Nabi Muhammad SAW melalui perantara Malaikat...", "Jibril", ["Jibril", "Mikail", "Israfil", "Izrail"]),
    ("Surah pertama yang terdapat di dalam mushaf Al-Qur'an adalah...", "Al-Fatihah", ["Al-Fatihah", "Al-Baqarah", "Al-Ikhlas", "An-Nas"]),
    ("Surah penutup atau yang terakhir di dalam mushaf Al-Qur'an adalah...", "An-Nas", ["An-Nas", "Al-Falaq", "Al-Ikhlas", "Al-Fatihah"]),
    ("Al-Qur'an diturunkan secara berangsur-angsur selama kurang lebih...", "22 tahun 2 bulan 22 hari", ["22 tahun 2 bulan 22 hari", "23 tahun 2 bulan 22 hari", "20 tahun 2 bulan 22 hari", "21 tahun 2 bulan 22 hari"]),
    ("Ayat yang pertama kali diturunkan kepada Nabi Muhammad SAW adalah...", "Al-'Alaq ayat 1-5", ["Al-'Alaq ayat 1-5", "Al-Fatihah ayat 1-7", "Al-Baqarah ayat 1-5", "Al-Mudassir ayat 1-5"]),
    ("Kota tempat sebagian besar surah Al-Qur'an diturunkan sebelum hijrah disebut surah golongan...", "Makkiyah", ["Makkiyah", "Madaniyah", "Mekkah", "Madinah"]),
    ("Surah-surah yang diturunkan setelah Nabi Muhammad SAW hijrah ke Madinah digolongkan sebagai surah...", "Madaniyah", ["Madaniyah", "Makkiyah", "Hijaz", "Yatsrib"])
]
for q, a, opts in quran_q:
    add_q(q, a, opts)

# Target exactly 500
random.shuffle(questions_list)
if len(questions_list) > 500:
    questions_list = questions_list[:500]

for i, q in enumerate(questions_list):
    q['id'] = f"agamaislam_{i+1}"

db_path = 'c:/laragon/www/Quiz/assets/datasets/agamaislam/database-agamaislam.json'
with open(db_path, 'w', encoding='utf-8') as f:
    json.dump(questions_list, f, indent=2, ensure_ascii=False)

print(f"Generated EXACTLY {len(questions_list)} unique questions and saved to {db_path}.")
