import json
import random

q_list = []
q_texts = set()
used_option_sets = set()

def q(text, correct, pool):
    if text in q_texts: return
    q_texts.add(text)
    
    # Try finding a unique combination of 4 options
    attempts = 0
    while True:
        # Pick 3 random wrong options from the pool (excluding the correct answer)
        wrongs = random.sample([x for x in pool if x != correct], 3)
        opts = [correct, wrongs[0], wrongs[1], wrongs[2]]
        
        # Sort options to check if this exact combo of 4 exists (order doesn't matter for the set check)
        opts_tuple = tuple(sorted(opts))
        
        if opts_tuple not in used_option_sets or attempts > 100:
            used_option_sets.add(opts_tuple)
            random.shuffle(opts)
            q_list.append({
                "text": text,
                "correctAnswer": correct,
                "options": opts,
                "type": "multiple_choice",
                "correctAnswerIndex": opts.index(correct)
            })
            break
        attempts += 1

# ==========================================
# 1. TATA SURYA (100 Soal)
# ==========================================
tata_surya_data = [
    ("Merkurius", "planet terkecil dan terdekat dari Matahari"),
    ("Venus", "planet terpanas di tata surya yang sering disebut Bintang Kejora"),
    ("Bumi", "satu-satunya planet yang diketahui memiliki kehidupan dan air cair"),
    ("Mars", "planet merah yang memiliki dua satelit bernama Phobos dan Deimos"),
    ("Yupiter", "planet gas raksasa terbesar di tata surya kita"),
    ("Saturnus", "planet gas raksasa yang terkenal memiliki cincin paling indah dan jelas"),
    ("Uranus", "planet es raksasa yang sumbu rotasinya sangat miring seperti menggelinding"),
    ("Neptunus", "planet terjauh dari Matahari yang berwarna biru gelap"),
    ("Matahari", "bintang yang menjadi pusat peredaran di tata surya kita"),
    ("Bulan", "satu-satunya satelit alami yang secara konstan mengelilingi Bumi"),
    ("Komet", "benda langit es berbatu yang membentuk ekor gas menyala saat mendekati matahari"),
    ("Meteor", "batu angkasa yang sedang jatuh dan terbakar habis di atmosfer bumi (bintang jatuh)"),
    ("Meteorit", "batu angkasa yang selamat dari pembakaran atmosfer dan menabrak tanah bumi"),
    ("Asteroid", "bongkahan batu angkasa besar yang sabuk utamanya terletak antara Mars dan Yupiter"),
    ("Galaksi Bima Sakti", "gugusan miliaran bintang di mana tata surya kita berada di dalamnya"),
    ("Gerhana Matahari", "fenomena saat posisi Bulan berada tepat di antara Bumi dan Matahari"),
    ("Gerhana Bulan", "fenomena saat posisi Bumi berada tepat di antara Bulan dan Matahari"),
    ("Rotasi Bumi", "gerakan perputaran Bumi pada porosnya yang menyebabkan siang dan malam"),
    ("Revolusi Bumi", "gerakan Bumi mengelilingi Matahari yang menyebabkan perubahan musim"),
    ("Troposfer", "lapisan atmosfer paling bawah tempat terjadinya segala fenomena cuaca awan dan hujan"),
    ("Stratosfer", "lapisan atmosfer bumi yang mengandung lapisan pelindung ozon"),
    ("Lapisan Ozon", "gas pelindung di atmosfer yang menyerap radiasi sinar ultraviolet matahari"),
    ("Satelit", "sebutan untuk benda langit apa pun yang mengorbit sebuah planet"),
    ("Pluto", "benda angkasa yang dulunya planet ke-9 namun kini diklasifikasikan sebagai planet katai"),
    ("Gravitasi", "gaya tarik semesta yang menjaga planet-planet tetap pada orbitnya mengelilingi matahari")
]

ts_terms = [t for t, d in tata_surya_data]
ts_descs = [d for t, d in tata_surya_data]

for term, desc in tata_surya_data:
    q(f"Dalam tata surya kita, {desc} dinamakan...", term, ts_terms)
    q(f"Ciri utama atau deskripsi yang paling tepat mengenai {term} adalah...", desc, ts_descs)

# Multiply questions to reach 100 by rewording
for term, desc in tata_surya_data:
    q(f"Benda langit atau fenomena yang dideskripsikan sebagai {desc} adalah...", term, ts_terms)
    q(f"Jika kita berbicara mengenai {term} di tata surya, hal yang paling tepat adalah...", desc, ts_descs)


# ==========================================
# 2. MANUSIA (100 Soal)
# ==========================================
manusia_data = [
    ("Jantung", "organ otot yang berfungsi secara terus-menerus memompa darah ke seluruh tubuh"),
    ("Paru-paru", "organ pernapasan utama manusia tempat pertukaran oksigen dan karbondioksida"),
    ("Ginjal", "organ penyaring darah yang menghasilkan zat sisa berupa urine (air seni)"),
    ("Hati (Liver)", "organ pencernaan pembongkar racun dan penghasil cairan empedu"),
    ("Lambung", "organ pencernaan yang meremas makanan dan mencampurnya dengan asam lambung (HCl)"),
    ("Usus Halus", "saluran pencernaan tempat utama penyarapan sari-sari makanan ke dalam darah"),
    ("Usus Besar", "saluran tempat pembusukan sisa makanan oleh bakteri dan penyerapan kembali air"),
    ("Eritrosit", "sel darah merah yang bertugas mengangkut oksigen ke seluruh sel tubuh"),
    ("Leukosit", "sel darah putih yang berfungsi sebagai sistem imun untuk membunuh kuman penyakit"),
    ("Trombosit", "keping darah yang berperan penting dalam proses pembekuan darah saat terjadi luka"),
    ("Plasma Darah", "cairan bening kekuningan pengangkut nutrisi gizi dan zat sisa metabolisme"),
    ("Aorta", "pembuluh nadi utama terbesar yang mengalirkan darah bersih kaya oksigen dari jantung"),
    ("Arteri (Nadi)", "pembuluh darah yang mengalirkan darah keluar meninggalkan jantung"),
    ("Vena (Balik)", "pembuluh darah berdinding tipis yang membawa darah kotor kembali menuju jantung"),
    ("Anemia", "penyakit kondisi tubuh kekurangan sel darah merah atau zat besi sehingga penderita lemas"),
    ("Leukemia", "kanker darah di mana sel darah putih diproduksi secara berlebihan dan merusak tubuh"),
    ("Hipertensi", "kondisi medis di mana tekanan darah di dalam pembuluh arteri sangat tinggi"),
    ("Femur", "tulang paha yang merupakan tulang terbesar dan terpanjang di tubuh manusia"),
    ("Sendi Engsel", "sendi seperti pada siku dan lutut yang hanya memungkinkan gerakan satu arah"),
    ("Sendi Peluru", "sendi pada panggul dan bahu yang memungkinkan gerakan bebas ke segala arah"),
    ("Alveolus", "gelembung-gelembung udara kecil di paru-paru sebagai titik akhir pertukaran gas"),
    ("Kornea", "selaput bening terluar pada mata yang melindungi bagian dalam mata"),
    ("Retina", "lapisan terdalam mata (selaput jala) yang peka cahaya untuk menangkap bayangan"),
    ("Koklea (Rumah Siput)", "saluran melingkar di telinga dalam yang mengubah getaran suara menjadi impuls saraf"),
    ("Enzim Ptialin", "enzim di air liur mulut yang berfungsi memecah karbohidrat menjadi gula sederhana")
]

m_terms = [t for t, d in manusia_data]
m_descs = [d for t, d in manusia_data]

for term, desc in manusia_data:
    q(f"Bagian anatomi tubuh manusia yang berfungsi sebagai {desc} adalah...", term, m_terms)
    q(f"Fungsi utama dari {term} di dalam sistem tubuh manusia adalah...", desc, m_descs)
    q(f"Di dalam organ tubuh manusia, {desc} dikenal dengan sebutan medis...", term, m_terms)
    q(f"Secara biologis, yang dimaksud dengan {term} pada manusia adalah...", desc, m_descs)


# ==========================================
# 3. HEWAN (100 Soal)
# ==========================================
hewan_data = [
    ("Karnivora", "kelompok hewan yang menjadikan daging sebagai sumber makanan utamanya"),
    ("Herbivora", "kelompok hewan yang hanya memakan tumbuh-tumbuhan saja"),
    ("Omnivora", "kelompok hewan yang memakan segala jenis makanan baik tumbuhan maupun daging"),
    ("Insektivora", "kelompok hewan yang makanan utamanya adalah berbagai jenis serangga"),
    ("Ovipar", "cara hewan berkembang biak dengan bertelur di luar tubuh induknya"),
    ("Vivipar", "cara hewan mamalia berkembang biak dengan melahirkan anaknya"),
    ("Ovovivipar", "cara hewan berkembang biak dengan bertelur dan menetas di dalam perut lalu dilahirkan"),
    ("Insang", "alat pernapasan utama di dalam air yang digunakan oleh ikan dan berudu"),
    ("Trakea", "saluran udara berongga yang menjadi alat pernapasan utama pada serangga"),
    ("Paru-paru dan Kulit", "kombinasi alat pernapasan yang digunakan oleh katak saat fase dewasa"),
    ("Ekolokasi", "kemampuan kelelawar dan lumba-lumba memantulkan gelombang suara untuk navigasi"),
    ("Mimikri", "kemampuan adaptasi bunglon mengubah warna kulit sesuai dengan tempat ia berada"),
    ("Autotomi", "mekanisme pertahanan diri cicak dengan secara sadar memutuskan ekornya"),
    ("Metamorfosis Sempurna", "daur hidup hewan yang melalui tahap telur, larva, kepompong (pupa), dan dewasa (imago)"),
    ("Metamorfosis Tidak Sempurna", "daur hidup hewan yang hanya melalui tahap telur, nimfa muda, dan dewasa"),
    ("Paus", "mamalia air raksasa terbesar di bumi yang bernapas dengan paru-paru"),
    ("Platipus", "hewan mamalia berdengung asli perairan Australia yang unik karena bertelur"),
    ("Komodo", "kadal raksasa purba endemik pulau di Indonesia yang air liurnya sangat beracun"),
    ("Porifera", "kelompok hewan avertebrata spons laut yang tubuhnya berpori-pori"),
    ("Mollusca", "kelompok hewan avertebrata bertubuh lunak seperti cumi, siput, dan kerang"),
    ("Arthropoda", "kelompok avertebrata dengan tubuh beruas-ruas seperti laba-laba, kepiting, dan serangga"),
    ("Hibernasi", "perilaku tidur panjang hewan di musim dingin ekstrim untuk menghemat cadangan energi"),
    ("Cheetah", "kucing predator darat asal Afrika yang memegang rekor lari tercepat di dunia"),
    ("Aves (Unggas)", "kelompok hewan bertulang belakang yang tubuhnya ditutupi bulu dan bersayap"),
    ("Amfibi", "kelompok hewan vertebrata yang siklus hidupnya bisa di dua alam yaitu air dan darat")
]

h_terms = [t for t, d in hewan_data]
h_descs = [d for t, d in hewan_data]

for term, desc in hewan_data:
    q(f"Dalam ilmu biologi zoologi, {desc} disebut dengan istilah...", term, h_terms)
    q(f"Pengertian yang sangat tepat untuk menjelaskan istilah {term} adalah...", desc, h_descs)
    q(f"Di dunia hewan, makhluk atau fenomena biologis yang didefinisikan sebagai {desc} adalah...", term, h_terms)
    q(f"Karakteristik atau sifat paling menonjol dari kelompok {term} yaitu...", desc, h_descs)


# ==========================================
# 4. TUMBUHAN (100 Soal)
# ==========================================
tumbuhan_data = [
    ("Fotosintesis", "proses pembuatan makanan pada tumbuhan hijau dengan bantuan cahaya matahari"),
    ("Klorofil", "zat pigmen hijau pada daun yang berfungsi menyerap energi cahaya matahari"),
    ("Stomata", "celah atau pori-pori pernapasan kecil yang terdapat di permukaan daun"),
    ("Lentisel", "celah udara pada bagian kulit batang pohon keras sebagai tempat pertukaran gas"),
    ("Oksigen", "gas pernapasan makhluk hidup yang dilepaskan tumbuhan sebagai hasil fotosintesis siang hari"),
    ("Glukosa", "zat gula hasil utama fotosintesis yang diedarkan sebagai sumber nutrisi tumbuhan"),
    ("Xilem", "jaringan pembuluh kayu yang mengangkut air dan mineral dari akar naik ke daun"),
    ("Floem", "jaringan pembuluh tapis yang mengedarkan hasil fotosintesis dari daun ke seluruh tubuh"),
    ("Kambium", "jaringan pertumbuhan meristem di dalam batang dikotil yang membesarkan diameter kayu"),
    ("Putik", "bagian tengah bunga yang berfungsi sebagai alat perkembangbiakan atau kelamin betina"),
    ("Benang Sari", "bagian bunga penghasil serbuk yang berfungsi sebagai alat kelamin jantan"),
    ("Mahkota Bunga", "perhiasan luar bunga yang berwarna warni indah untuk menarik perhatian serangga pembantu penyerbukan"),
    ("Mencangkok", "cara perbanyakan vegetatif buatan dengan mengelupas kulit dahan dan dibungkus tanah"),
    ("Spora", "alat perkembangbiakan alami berukuran sangat kecil pada tumbuhan purba paku dan lumut"),
    ("Umbi Lapis", "cara tanaman seperti bawang merah dan bawang putih memperbanyak diri di dalam tanah"),
    ("Tunas Adventif", "anakan daun baru yang tumbuh di ujung pinggiran daun, contohnya pada cocor bebek"),
    ("Fototropisme", "gerak respons pembengkokan arah tumbuh pucuk batang yang selalu menuju datangnya sinar"),
    ("Seismonasti", "gerak respons cepat daun putri malu yang segera mengatup saat menerima sentuhan mekanis"),
    ("Kaktus", "tanaman gurun sukulen yang memodifikasi daunnya menjadi duri untuk menekan penguapan air"),
    ("Teratai", "tanaman air tenang yang daunnya bundar melebar tipis agar bisa mengapung dan mudah menguap"),
    ("Bakau (Mangrove)", "pohon pesisir pantai berlumpur yang menumbuhkan akar napas menjulang ke atas"),
    ("Kantong Semar", "tumbuhan unik yang beradaptasi menangkap serangga cair untuk memenuhi kebutuhan nitrogennya"),
    ("Dikotil", "kelompok tumbuhan berbiji ganda atau belah yang batangnya berkayu kokoh memiliki kambium"),
    ("Monokotil", "kelompok tumbuhan berbiji tunggal berkeping satu dengan susunan akar serabut"),
    ("Rafflesia arnoldii", "bunga parasit raksasa berbau bangkai endemik hutan Sumatera yang merupakan bunga terbesar di bumi")
]

t_terms = [t for t, d in tumbuhan_data]
t_descs = [d for t, d in tumbuhan_data]

for term, desc in tumbuhan_data:
    q(f"Mekanisme biologi anatomi tumbuhan di mana {desc} dikenal sebagai...", term, t_terms)
    q(f"Fungsi biologis paling utama dari {term} bagi kelangsungan hidup tumbuhan adalah...", desc, t_descs)
    q(f"Sesuai konsep biologi flora, istilah penamaan untuk {desc} adalah...", term, t_terms)
    q(f"Jika membahas ciri atau aktivitas {term} pada tumbuhan, maka yang dimaksud adalah...", desc, t_descs)


# ==========================================
# 5. EKOSISTEM (100 Soal)
# ==========================================
ekosistem_data = [
    ("Simbiosis Mutualisme", "hubungan saling menguntungkan secara mutlak antara dua spesies makhluk hidup yang berbeda"),
    ("Simbiosis Komensalisme", "hubungan dua makhluk di mana satu pihak untung namun pihak yang lain sama sekali tidak dirugikan"),
    ("Simbiosis Parasitisme", "hubungan di mana satu parasit beruntung menghisap nutrisi dan merugikan inang penderitanya"),
    ("Rantai Makanan", "peristiwa urutan linear makan dan dimakan antar makhluk hidup dengan arah dan tingkatan tertentu"),
    ("Produsen", "makhluk hidup mandiri pembuat makanan sendiri seperti tumbuhan di dasar awal rantai makanan"),
    ("Konsumen Tingkat 1", "makhluk hidup pemakan tumbuhan (herbivora) yang menduduki urutan kedua setelah tanaman"),
    ("Konsumen Puncak", "predator tertinggi dalam piramida makanan yang tidak dimakan oleh hewan lain secara alami"),
    ("Dekomposer (Pengurai)", "organisme bakteri dan jamur yang membusukkan bangkai mati menjadi nutrisi kembali ke tanah"),
    ("Hutan Hujan Tropis", "bioma hutan di garis ekuator dengan curah hujan deras sangat lebat serta keanekaragaman hayati tertinggi"),
    ("Sabana", "bioma padang rumput yang sangat luas namun sesekali diselingi oleh beberapa semak atau pohon tunggal"),
    ("Gurun", "bioma lingkungan kering kerontang berpasir dengan kelembaban sangat minim curah hujan hampir nihil"),
    ("Taiga", "bioma lingkungan konifer hutan pinus homogen yang tahan akan hawa dingin beku sepanjang tahun"),
    ("Tundra", "bioma padang lumut beku terdingin dan terluar kutub utara yang tidak dapat ditumbuhi pohon kayu"),
    ("Komponen Abiotik", "seluruh benda tak hidup atau fisik di lingkungan alam seperti batu, udara, air, dan cahaya"),
    ("Komponen Biotik", "seluruh benda bernyawa atau organisme hidup mulai dari bakteri terkecil hingga hewan besar di suatu area"),
    ("Autotrof", "istilah untuk makhluk penyedia makanan murni mandiri seperti alga hijau dan pohon berdaun"),
    ("Heterotrof", "istilah untuk organisme konsumtif yang selalu bergantung memakan makhluk lain demi energi hidupnya"),
    ("Ekosistem Alami", "tatanan alamiah lingkungan interaksi harmonis biotik abiotik tanpa sedikitpun perancangan manusia"),
    ("Ekosistem Buatan", "lingkungan alam artifisial seperti sawah, waduk, atau taman yang sengaja direkayasa oleh manusia"),
    ("Pencemaran Udara", "penurunan kualitas udara bebas karena meningkatnya emisi gas buang karbon dari corong pabrik maupun kendaraan"),
    ("Pencemaran Air", "perusakan kualitas air danau atau laut oleh buangan limbah kimia racun, sampah plastik, atau tumpahan minyak"),
    ("Pencemaran Tanah", "kerusakan kualitas kesuburan tanah gembur akibat pembuangan limbah kimia anorganik pestisida padat beracun"),
    ("Eutrofikasi", "ledakan populasi ganggang air subur secara tak wajar di waduk akibat pencemaran sisa pupuk kimia pertanian"),
    ("Pemanasan Global", "kenaikan suhu ekstrem rata-rata permukaan bumi akibat terperangkapnya gas rumah kaca atmosfer"),
    ("Reboisasi", "kegiatan penghijauan penanaman kembali tegakan pohon di hutan lindung yang sebelumnya telah gundul")
]

e_terms = [t for t, d in ekosistem_data]
e_descs = [d for t, d in ekosistem_data]

for term, desc in ekosistem_data:
    q(f"Konsep dasar ilmu ekologi lingkungan menyebutkan bahwa {desc} diistilahkan sebagai...", term, e_terms)
    q(f"Definisi terlengkap yang bisa menjabarkan istilah lingkungan {term} adalah...", desc, e_descs)
    q(f"Dalam interaksi di lingkungan sekitarnya, kondisi {desc} sangat erat dinamakan...", term, e_terms)
    q(f"Apakah maksud dari istilah {term} di dalam dinamika kehidupan di alam bebas?", desc, e_descs)

# ==========================================
# FINALIZATION
# ==========================================

# Cap precisely at 500
random.shuffle(q_list)
if len(q_list) > 500:
    q_list = q_list[:500]

for idx, q_obj in enumerate(q_list):
    q_obj['id'] = f"ilmupengetahuanalam_{idx+1}"

db_path = 'c:/laragon/www/Quiz/assets/datasets/ilmupengetahuanalam/database-ilmupengetahuanalam.json'
with open(db_path, 'w', encoding='utf-8') as f:
    json.dump(q_list, f, indent=2, ensure_ascii=False)

print(f"Generated EXACTLY {len(q_list)} completely unique biology/astronomy questions and saved to {db_path}.")
