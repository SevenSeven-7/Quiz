import json
import random

q_list = []
q_texts = set()

def q(text, correct, w1, w2, w3):
    if text in q_texts: return
    q_texts.add(text)
    
    opts = [correct, w1, w2, w3]
    unique_opts = []
    for o in opts:
        if o not in unique_opts:
            unique_opts.append(o)
            
    while len(unique_opts) < 4:
        unique_opts.append("Opsi Salah " + str(random.randint(1,10000)))
        
    random.shuffle(unique_opts)
    q_list.append({
        "text": text,
        "correctAnswer": correct,
        "options": unique_opts,
        "type": "multiple_choice",
        "correctAnswerIndex": unique_opts.index(correct)
    })

# 1. Peta / Geografi Dasar (10)
geo_dasar = [
    ("Gambaran permukaan bumi pada bidang datar disebut...", "Peta", "Globe", "Atlas", "Denah"),
    ("Kumpulan peta yang dibukukan menjadi satu disebut...", "Atlas", "Globe", "Katalog", "Ensiklopedia"),
    ("Tiruan bola bumi dalam bentuk kecil disebut...", "Globe", "Peta", "Atlas", "Miniatur"),
    ("Perbandingan jarak peta dengan jarak sebenarnya disebut...", "Skala", "Legenda", "Garis Lintang", "Simbol"),
    ("Garis khayal yang membelah bumi menjadi utara dan selatan disebut...", "Khatulistiwa", "Garis Bujur", "Garis Wallace", "Garis Weber"),
    ("Simbol warna hijau pada peta biasanya menggambarkan...", "Dataran Rendah", "Pegunungan", "Laut Dalam", "Gurun Pasir"),
    ("Simbol warna cokelat pada peta menunjukkan area...", "Pegunungan", "Dataran Rendah", "Laut Dangkal", "Danau"),
    ("Warna biru pada peta digunakan untuk simbol...", "Perairan", "Hutan", "Gurun", "Dataran Tinggi"),
    ("Indonesia terletak di antara dua benua, yaitu...", "Asia dan Australia", "Asia dan Afrika", "Asia dan Eropa", "Amerika dan Eropa"),
    ("Indonesia terletak di antara dua samudra, yaitu...", "Hindia dan Pasifik", "Atlantik dan Pasifik", "Hindia dan Arktik", "Atlantik dan Arktik")
]
for text, c, w1, w2, w3 in geo_dasar: q(text, c, w1, w2, w3)

# 2. Ibukota Provinsi (38)
prov_capitals = [
    ("Nanggroe Aceh Darussalam", "Banda Aceh"), ("Sumatera Utara", "Medan"), ("Sumatera Barat", "Padang"),
    ("Riau", "Pekanbaru"), ("Kepulauan Riau", "Tanjungpinang"), ("Jambi", "Jambi"),
    ("Sumatera Selatan", "Palembang"), ("Bengkulu", "Bengkulu"), ("Lampung", "Bandar Lampung"),
    ("Kepulauan Bangka Belitung", "Pangkalpinang"), ("DKI Jakarta", "Jakarta"), ("Jawa Barat", "Bandung"),
    ("Banten", "Serang"), ("Jawa Tengah", "Semarang"), ("DI Yogyakarta", "Yogyakarta"),
    ("Jawa Timur", "Surabaya"), ("Bali", "Denpasar"), ("Nusa Tenggara Barat", "Mataram"),
    ("Nusa Tenggara Timur", "Kupang"), ("Kalimantan Barat", "Pontianak"), ("Kalimantan Tengah", "Palangka Raya"),
    ("Kalimantan Selatan", "Banjarmasin"), ("Kalimantan Timur", "Samarinda"), ("Kalimantan Utara", "Tanjung Selor"),
    ("Sulawesi Utara", "Manado"), ("Gorontalo", "Gorontalo"), ("Sulawesi Tengah", "Palu"),
    ("Sulawesi Barat", "Mamuju"), ("Sulawesi Selatan", "Makassar"), ("Sulawesi Tenggara", "Kendari"),
    ("Maluku", "Ambon"), ("Maluku Utara", "Sofifi"), ("Papua Barat", "Manokwari"),
    ("Papua", "Jayapura"), ("Papua Selatan", "Merauke"), ("Papua Tengah", "Nabire"),
    ("Papua Pegunungan", "Wamena"), ("Papua Barat Daya", "Sorong")
]
for prov, cap in prov_capitals:
    wrongs = random.sample(list(set([c for p, c in prov_capitals if c != cap])), 3)
    q(f"Ibu kota dari provinsi {prov} adalah...", cap, wrongs[0], wrongs[1], wrongs[2])

# 3. Inverse Ibukota Provinsi (38)
for prov, cap in prov_capitals:
    wrongs = random.sample(list(set([p for p, c in prov_capitals if p != prov])), 3)
    q(f"Kota {cap} merupakan ibu kota dari provinsi...", prov, wrongs[0], wrongs[1], wrongs[2])

# 4. Sumber Daya Alam (15)
sda = [
    ("Bangka Belitung", "Timah"), ("Mimika, Papua", "Emas & Tembaga"), ("Bontang, Kaltim", "Gas Alam"),
    ("Sawahlunto", "Batu Bara"), ("Cepu", "Minyak Bumi"), ("Martapura", "Intan"),
    ("Soroako", "Nikel"), ("Pulau Buton", "Aspal"), ("Cilacap", "Minyak Bumi"),
    ("Bukit Asam", "Batu Bara"), ("Bintan", "Bauksit"), ("Gresik", "Semen"),
    ("Lhokseumawe", "Gas Alam"), ("Plaju", "Minyak Bumi"), ("Rejang Lebong", "Emas")
]
for lokasi, hasil in sda:
    wrongs = random.sample(list(set([h for l, h in sda if h != hasil])), 3)
    q(f"Daerah {lokasi} dikenal sebagai salah satu daerah penghasil tambang...", hasil, wrongs[0], wrongs[1], wrongs[2])

# 5. Mitigasi Bencana & Iklim
bencana = [
    ("Jika terjadi gempa bumi saat di dalam kelas, hal pertama yang dilakukan adalah...", "Berlindung di bawah meja", "Lari keluar berdesakan", "Diam saja di kursi", "Menghubungi pemadam"),
    ("Jika air laut tiba-tiba surut drastis setelah gempa, kita harus...", "Lari ke tempat tinggi", "Mengambil ikan di pantai", "Berdiam diri di rumah", "Mendekati bibir pantai"),
    ("Untuk mencegah tanah longsor di lahan miring, teknik pertanian yang baik adalah...", "Terasering", "Pembakaran Hutan", "Ladang Berpindah", "Menebang Pohon"),
    ("Penyebab utama terjadinya pemanasan global adalah...", "Efek rumah kaca", "Angin topan", "Gempa tektonik", "Pasang surut air laut"),
    ("Musim kemarau di Indonesia terjadi akibat hembusan angin...", "Muson Timur", "Muson Barat", "Angin Darat", "Angin Lembah"),
    ("Angin Muson Barat membawa banyak uap air dan menyebabkan...", "Musim Hujan", "Musim Kemarau", "Tsunami", "Tanah Longsor"),
    ("Tindakan yang tepat saat terjadi angin puting beliung adalah...", "Berlindung di ruangan kokoh", "Berdiri di bawah pohon", "Bermain di tanah lapang", "Memanjat tiang listrik"),
    ("Bencana alam akibat pergeseran lempeng bumi disebut gempa...", "Tektonik", "Vulkanik", "Susulan", "Runtuhan")
]
for text, c, w1, w2, w3 in bencana: q(text, c, w1, w2, w3)

# 6. Sejarah / Tokoh Pahlawan Asal Daerah (14)
tokoh = [
    ("Cut Nyak Dien", "Aceh"), ("Pattimura", "Maluku"), ("Pangeran Diponegoro", "Jawa Tengah"),
    ("Sultan Hasanuddin", "Sulawesi Selatan"), ("Pangeran Antasari", "Kalimantan Selatan"),
    ("Tuanku Imam Bonjol", "Sumatera Barat"), ("I Gusti Ngurah Rai", "Bali"),
    ("Sisingamangaraja XII", "Sumatera Utara"), ("Ki Hajar Dewantara", "Yogyakarta"),
    ("Teuku Umar", "Aceh"), ("Martha Christina Tiahahu", "Maluku"), ("Silas Papare", "Papua"),
    ("Nyi Ageng Serang", "Jawa Tengah"), ("Raden Dewi Sartika", "Jawa Barat")
]
for t, daerah in tokoh:
    wrongs = random.sample(list(set([d for p, d in tokoh if d != daerah])), 3)
    q(f"Pahlawan nasional {t} berasal dari daerah...", daerah, wrongs[0], wrongs[1], wrongs[2])

# 7. Julukan Tokoh / Sejarah Kemerdekaan (9)
sejarah_kemerdekaan = [
    ("Bapak Proklamator Indonesia adalah...", "Ir. Soekarno", "Mohammad Hatta", "Jenderal Soedirman", "B.J. Habibie"),
    ("Tokoh yang menjahit Bendera Merah Putih adalah...", "Ibu Fatmawati", "Ibu Kartini", "Cut Nyak Dien", "Dewi Sartika"),
    ("Teks Proklamasi Kemerdekaan RI diketik oleh...", "Sayuti Melik", "Soekarni", "Ahmad Soebardjo", "Wikana"),
    ("Panglima Besar TNI pertama yang melakukan perang gerilya adalah...", "Jenderal Soedirman", "Jenderal A.H. Nasution", "Jenderal Ahmad Yani", "Letjen MT Haryono"),
    ("Bapak Pendidikan Nasional Indonesia adalah...", "Ki Hajar Dewantara", "Dr. Soetomo", "Wahid Hasyim", "HOS Tjokroaminoto"),
    ("Sumpah Pemuda diikrarkan pada tahun...", "1928", "1908", "1945", "1920"),
    ("Hari Kemerdekaan Republik Indonesia diperingati setiap tanggal...", "17 Agustus", "20 Mei", "28 Oktober", "10 November"),
    ("Hari Pahlawan Nasional diperingati setiap tanggal...", "10 November", "1 Juni", "17 Agustus", "21 April"),
    ("Hari Kebangkitan Nasional diperingati setiap tanggal...", "20 Mei", "28 Oktober", "1 Oktober", "17 Agustus")
]
for text, c, w1, w2, w3 in sejarah_kemerdekaan: q(text, c, w1, w2, w3)

# 8. World Countries (190) -> Generate forward and reverse to reach 500 naturally
world_countries = [
    ("Afghanistan", "Kabul"), ("Albania", "Tirana"), ("Aljazair", "Aljir"), ("Andorra", "Andorra la Vella"),
    ("Angola", "Luanda"), ("Antigua dan Barbuda", "St. John's"), ("Argentina", "Buenos Aires"), ("Armenia", "Yerevan"),
    ("Australia", "Canberra"), ("Austria", "Wina"), ("Azerbaijan", "Baku"), ("Bahama", "Nassau"),
    ("Bahrain", "Manama"), ("Bangladesh", "Dhaka"), ("Barbados", "Bridgetown"), ("Belarus", "Minsk"),
    ("Belgia", "Brussel"), ("Belize", "Belmopan"), ("Benin", "Porto-Novo"), ("Bhutan", "Thimphu"),
    ("Bolivia", "Sucre"), ("Bosnia dan Herzegovina", "Sarajevo"), ("Botswana", "Gaborone"), ("Brasil", "Brasilia"),
    ("Brunei", "Bandar Seri Begawan"), ("Bulgaria", "Sofia"), ("Burkina Faso", "Ouagadougou"), ("Burundi", "Gitega"),
    ("Kamboja", "Phnom Penh"), ("Kamerun", "Yaounde"), ("Kanada", "Ottawa"), ("Tanjung Verde", "Praia"),
    ("Republik Afrika Tengah", "Bangui"), ("Chad", "N'Djamena"), ("Chili", "Santiago"), ("Tiongkok", "Beijing"),
    ("Kolombia", "Bogota"), ("Komoro", "Moroni"), ("Kongo", "Brazzaville"), ("Kosta Rika", "San Jose"),
    ("Kroasia", "Zagreb"), ("Kuba", "Havana"), ("Siprus", "Nikosia"), ("Ceko", "Praha"),
    ("Denmark", "Kopenhagen"), ("Djibouti", "Djibouti"), ("Dominika", "Roseau"), ("Republik Dominika", "Santo Domingo"),
    ("Timor Leste", "Dili"), ("Ekuador", "Quito"), ("Mesir", "Kairo"), ("El Salvador", "San Salvador"),
    ("Guinea Khatulistiwa", "Malabo"), ("Eritrea", "Asmara"), ("Estonia", "Tallinn"), ("Eswatini", "Mbabane"),
    ("Ethiopia", "Addis Ababa"), ("Fiji", "Suva"), ("Finlandia", "Helsinki"), ("Prancis", "Paris"),
    ("Gabon", "Libreville"), ("Gambia", "Banjul"), ("Georgia", "Tbilisi"), ("Jerman", "Berlin"),
    ("Ghana", "Accra"), ("Yunani", "Athena"), ("Grenada", "St. George's"), ("Guatemala", "Guatemala City"),
    ("Guinea", "Conakry"), ("Guinea-Bissau", "Bissau"), ("Guyana", "Georgetown"), ("Haiti", "Port-au-Prince"),
    ("Honduras", "Tegucigalpa"), ("Hungaria", "Budapest"), ("Islandia", "Reykjavik"), ("India", "New Delhi"),
    ("Indonesia", "Jakarta"), ("Iran", "Teheran"), ("Irak", "Baghdad"), ("Irlandia", "Dublin"),
    ("Israel", "Yerusalem"), ("Italia", "Roma"), ("Pantai Gading", "Yamoussoukro"), ("Jamaika", "Kingston"),
    ("Jepang", "Tokyo"), ("Yordania", "Amman"), ("Kazakhstan", "Astana"), ("Kenya", "Nairobi"),
    ("Kiribati", "Tarawa Selatan"), ("Korea Utara", "Pyongyang"), ("Korea Selatan", "Seoul"), ("Kuwait", "Banda Kuwait"),
    ("Kirgistan", "Bishkek"), ("Laos", "Vientiane"), ("Latvia", "Riga"), ("Lebanon", "Beirut"),
    ("Lesotho", "Maseru"), ("Liberia", "Monrovia"), ("Libya", "Tripoli"), ("Liechtenstein", "Vaduz"),
    ("Lituania", "Vilnius"), ("Luksemburg", "Luksemburg"), ("Madagaskar", "Antananarivo"), ("Malawi", "Lilongwe"),
    ("Malaysia", "Kuala Lumpur"), ("Maladewa", "Male"), ("Mali", "Bamako"), ("Malta", "Valletta"),
    ("Kepulauan Marshall", "Majuro"), ("Mauritania", "Nouakchott"), ("Mauritius", "Port Louis"), ("Meksiko", "Mexico City"),
    ("Mikronesia", "Palikir"), ("Moldova", "Chisinau"), ("Monako", "Monako"), ("Mongolia", "Ulaanbaatar"),
    ("Montenegro", "Podgorica"), ("Maroko", "Rabat"), ("Mozambik", "Maputo"), ("Myanmar", "Naypyidaw"),
    ("Namibia", "Windhoek"), ("Nauru", "Yaren"), ("Nepal", "Kathmandu"), ("Belanda", "Amsterdam"),
    ("Selandia Baru", "Wellington"), ("Nikaragua", "Managua"), ("Niger", "Niamey"), ("Nigeria", "Abuja"),
    ("Makedonia Utara", "Skopje"), ("Norwegia", "Oslo"), ("Oman", "Muskat"), ("Pakistan", "Islamabad"),
    ("Palau", "Ngerulmud"), ("Palestina", "Yerusalem Timur"), ("Panama", "Panama City"), ("Papua Nugini", "Port Moresby"),
    ("Paraguay", "Asuncion"), ("Peru", "Lima"), ("Filipina", "Manila"), ("Polandia", "Warsawa"),
    ("Portugal", "Lisboa"), ("Qatar", "Doha"), ("Rumania", "Bukares"), ("Rusia", "Moskow"),
    ("Rwanda", "Kigali"), ("Saint Kitts dan Nevis", "Basseterre"), ("Saint Lucia", "Castries"), ("Saint Vincent", "Kingstown"),
    ("Samoa", "Apia"), ("San Marino", "San Marino"), ("Sao Tome dan Principe", "Sao Tome"), ("Arab Saudi", "Riyadh"),
    ("Senegal", "Dakar"), ("Serbia", "Beograd"), ("Seychelles", "Victoria"), ("Sierra Leone", "Freetown"),
    ("Singapura", "Singapura"), ("Slovakia", "Bratislava"), ("Slovenia", "Ljubljana"), ("Kepulauan Solomon", "Honiara"),
    ("Somalia", "Mogadishu"), ("Afrika Selatan", "Pretoria"), ("Sudan Selatan", "Juba"), ("Spanyol", "Madrid"),
    ("Sri Lanka", "Kolombo"), ("Sudan", "Khartoum"), ("Suriname", "Paramaribo"), ("Swedia", "Stockholm"),
    ("Swiss", "Bern"), ("Suriah", "Damaskus"), ("Tajikistan", "Dushanbe"), ("Tanzania", "Dodoma"),
    ("Thailand", "Bangkok"), ("Togo", "Lome"), ("Tonga", "Nukuʻalofa"), ("Trinidad dan Tobago", "Port of Spain"),
    ("Tunisia", "Tunis"), ("Turki", "Ankara"), ("Turkmenistan", "Ashgabat"), ("Tuvalu", "Funafuti"),
    ("Uganda", "Kampala"), ("Ukraina", "Kyiv"), ("Uni Emirat Arab", "Abu Dhabi"), ("Inggris Raya", "London"),
    ("Amerika Serikat", "Washington, D.C."), ("Uruguay", "Montevideo"), ("Uzbekistan", "Tashkent"), ("Vanuatu", "Port Vila"),
    ("Vatikan", "Vatikan"), ("Venezuela", "Caracas"), ("Vietnam", "Hanoi"), ("Yaman", "Sanaa"),
    ("Zambia", "Lusaka"), ("Zimbabwe", "Harare")
]

# Randomize to distribute them nicely
random.shuffle(world_countries)

# Add "Ibukota dari negara X adalah..."
for country, cap in world_countries:
    if len(q_list) >= 500: break
    wrongs = random.sample(list(set([c for n, c in world_countries if c != cap])), 3)
    q(f"Ibu kota dari negara {country} adalah...", cap, wrongs[0], wrongs[1], wrongs[2])

# Add "Kota Y adalah ibu kota dari negara..."
for country, cap in world_countries:
    if len(q_list) >= 500: break
    wrongs = random.sample(list(set([n for n, c in world_countries if n != country])), 3)
    q(f"Kota {cap} merupakan ibu kota dari negara...", country, wrongs[0], wrongs[1], wrongs[2])

# Just in case we are STILL short (unlikely, total pool is ~100 + 380 = 480). Wait, 10+38+38+15+8+14+9 = 132. 
# 132 + 190 + 190 = 512. It will perfectly hit 500 inside the reverse world_countries loop.

if len(q_list) > 500:
    q_list = q_list[:500]

for idx, q_obj in enumerate(q_list):
    q_obj['id'] = f"ilmupengetahuansosial_{idx+1}"

db_path = 'c:/laragon/www/Quiz/assets/datasets/ilmupengetahuansosial/database-ilmupengetahuansosial.json'
with open(db_path, 'w', encoding='utf-8') as f:
    json.dump(q_list, f, indent=2, ensure_ascii=False)

print(f"Generated EXACTLY {len(q_list)} unique questions and saved to {db_path}.")
