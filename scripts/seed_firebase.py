import requests
import json
import random
import string
import time

PROJECT_ID = "quiz-564f1"
BASE_URL = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents"

def generate_random_id():
    return ''.join(random.choices(string.ascii_letters + string.digits, k=16))

def build_firestore_document(doc_id, part_id, q_text, answer, wrongs):
    # Random key for random fetching
    random_key = random.randint(0, 1000000)
    
    options = [answer] + wrongs
    random.shuffle(options)
    correct_idx = options.index(answer)
    
    fields = {
        "id": {"stringValue": doc_id},
        "partId": {"stringValue": part_id},
        "text": {"stringValue": q_text},
        "type": {"stringValue": "mcq"},
        "correctAnswerIndex": {"integerValue": correct_idx},
        "correctAnswer": {"stringValue": answer},
        "random_key": {"integerValue": random_key},
        "options": {
            "arrayValue": {
                "values": [{"stringValue": o} for o in options]
            }
        }
    }
    
    return {
        "update": {
            "name": f"projects/{PROJECT_ID}/databases/(default)/documents/questions_pool/{doc_id}",
            "fields": fields
        }
    }

def generate_agama(part_id):
    malaikat_data = {"Jibril": "Membawa wahyu", "Mikail": "Menurunkan rezeki/hujan", "Israfil": "Meniup sangkakala", "Izrail": "Mencabut nyawa", "Munkar": "Menanya di kubur", "Nakir": "Menanya di kubur", "Raqib": "Mencatat amal baik", "Atid": "Mencatat amal buruk", "Malik": "Menjaga neraka", "Ridwan": "Menjaga surga"}
    nabi_data = {"Musa AS": "Tongkat menjadi ular", "Ibrahim AS": "Tidak hangus dibakar api", "Sulaiman AS": "Berbicara dengan hewan", "Isa AS": "Menyembuhkan orang sakit", "Muhammad SAW": "Al-Qur'an", "Nuh AS": "Membuat kapal besar", "Ayyub AS": "Kesabaran luar biasa"}
    kitab_data = {"Al-Qur'an": "Muhammad SAW", "Injil": "Isa AS", "Taurat": "Musa AS", "Zabur": "Daud AS"}
    rukun_iman = {"Satu": "Allah", "Dua": "Malaikat", "Tiga": "Kitab", "Empat": "Rasul", "Lima": "Hari Kiamat", "Enam": "Qada dan Qadar"}
    shalat = {"Subuh": "2", "Dzuhur": "4", "Ashar": "4", "Maghrib": "3", "Isya": "4"}
    
    docs = []
    for _ in range(2000):
        t = random.randint(0, 4)
        if t == 0:
            k, v = random.choice(list(malaikat_data.items()))
            q = f"Malaikat {k} memiliki tugas..."
            wrongs = [val for val in malaikat_data.values() if val != v]
        elif t == 1:
            k, v = random.choice(list(nabi_data.items()))
            q = f"Mukjizat atau ciri khas Nabi {k} adalah..."
            wrongs = [val for val in nabi_data.values() if val != v]
        elif t == 2:
            k, v = random.choice(list(kitab_data.items()))
            q = f"Kitab suci {k} diturunkan kepada Nabi..."
            wrongs = [val for val in kitab_data.values() if val != v]
        elif t == 3:
            k, v = random.choice(list(rukun_iman.items()))
            q = f"Rukun Iman yang ke-{k} adalah iman kepada..."
            wrongs = [val for val in rukun_iman.values() if val != v]
        else:
            k, v = random.choice(list(shalat.items()))
            q = f"Jumlah rakaat shalat {k} adalah..."
            wrongs = ["1", "2", "3", "4", "5", "6"]
            if v in wrongs:
                wrongs.remove(v)
            
        random.shuffle(wrongs)
        docs.append(build_firestore_document(generate_random_id(), part_id, q, v, wrongs[:3]))
    return docs

def generate_indo(part_id):
    kata_baku = {"Apotek": "Apotik", "Sistem": "Sistim", "Aktivitas": "Aktifitas", "Nasihat": "Nasehat", "Izin": "Ijin", "Praktik": "Praktek", "Jadwal": "Jadual", "Karier": "Karir", "Detail": "Detil", "Gua": "Goa"}
    sinonim = {"Pintar": "Pandai", "Cepat": "Laju", "Indah": "Cantik", "Besar": "Raksasa", "Matahari": "Surya", "Bulan": "Rembulan", "Bohong": "Dusta", "Asli": "Orisinal", "Haus": "Dahaga"}
    antonim = {"Panjang": "Pendek", "Besar": "Kecil", "Gelap": "Terang", "Cepat": "Lambat", "Kaya": "Miskin", "Kuat": "Lemah", "Panas": "Dingin", "Rajin": "Malas"}
    
    docs = []
    for _ in range(2000):
        t = random.randint(0, 2)
        if t == 0:
            k, v = random.choice(list(kata_baku.items()))
            q = f"Manakah penulisan kata baku yang benar untuk kata '{v}'?"
            wrongs = [v, f"Ke{v}", f"Penge{v}", f"{v}an"]
            ans = k
        elif t == 1:
            k, v = random.choice(list(sinonim.items()))
            q = f"Persamaan kata (sinonim) dari '{k}' adalah..."
            wrongs = [val for val in sinonim.values() if val != v]
            ans = v
        else:
            k, v = random.choice(list(antonim.items()))
            q = f"Lawan kata (antonim) dari '{k}' adalah..."
            wrongs = [val for val in antonim.values() if val != v]
            ans = v
            
        random.shuffle(wrongs)
        docs.append(build_firestore_document(generate_random_id(), part_id, q, ans, wrongs[:3]))
    return docs

def generate_math(part_id):
    docs = []
    for _ in range(2000):
        op = random.choice(['+', '-', '*'])
        a = random.randint(1, 50)
        b = random.randint(1, 20)
        if op == '+':
            q = f"Berapakah hasil dari {a} + {b}?"
            ans = a + b
        elif op == '-':
            q = f"Berapakah hasil dari {a} - {b}?"
            ans = a - b
        else:
            q = f"Berapakah hasil dari {a} x {b}?"
            ans = a * b
            
        wrongs = [ans + random.randint(1, 10), ans - random.randint(1, 10), ans + random.randint(11, 20)]
        docs.append(build_firestore_document(generate_random_id(), part_id, q, str(ans), [str(w) for w in wrongs]))
    return docs

def generate_ipa(part_id):
    hewan = {"Kucing": "Karnivora", "Sapi": "Herbivora", "Beruang": "Omnivora", "Singa": "Karnivora", "Kambing": "Herbivora", "Ayam": "Omnivora", "Buaya": "Karnivora", "Gajah": "Herbivora"}
    planet = {"Bumi": "Kehidupan", "Mars": "Planet Merah", "Jupiter": "Paling besar", "Saturnus": "Memiliki cincin", "Merkurius": "Paling dekat", "Neptunus": "Paling jauh"}
    fisika = {"Padat ke Cair": "Mencair", "Cair ke Gas": "Menguap", "Gas ke Cair": "Mengembun", "Cair ke Padat": "Membeku", "Padat ke Gas": "Menyublim"}
    
    docs = []
    for _ in range(2000):
        t = random.randint(0, 2)
        if t == 0:
            k, v = random.choice(list(hewan.items()))
            q = f"Berdasarkan jenis makanannya, hewan {k} termasuk golongan..."
            wrongs = ["Karnivora", "Herbivora", "Omnivora", "Insektivora"]
            if v in wrongs: wrongs.remove(v)
        elif t == 1:
            k, v = random.choice(list(planet.items()))
            q = f"Ciri utama dari planet {k} adalah..."
            wrongs = [val for val in planet.values() if val != v]
        else:
            k, v = random.choice(list(fisika.items()))
            q = f"Perubahan wujud benda dari {k} disebut..."
            wrongs = [val for val in fisika.values() if val != v]
            
        random.shuffle(wrongs)
        docs.append(build_firestore_document(generate_random_id(), part_id, q, v, wrongs[:3]))
    return docs

def generate_ips(part_id):
    ibukota = {"Indonesia": "Jakarta", "Jepang": "Tokyo", "Malaysia": "Kuala Lumpur", "Thailand": "Bangkok", "Inggris": "London", "Prancis": "Paris", "Korea Selatan": "Seoul"}
    provinsi = {"Jawa Barat": "Bandung", "Jawa Timur": "Surabaya", "Jawa Tengah": "Semarang", "Bali": "Denpasar", "Sumatera Utara": "Medan", "Papua": "Jayapura"}
    pahlawan = {"Cut Nyak Dien": "Aceh", "Pangeran Diponegoro": "Jawa", "Pattimura": "Maluku", "Imam Bonjol": "Sumatera Barat", "Hasanuddin": "Sulawesi Selatan"}
    
    docs = []
    for _ in range(2000):
        t = random.randint(0, 2)
        if t == 0:
            k, v = random.choice(list(ibukota.items()))
            q = f"Ibu kota dari negara {k} adalah..."
            wrongs = [val for val in ibukota.values() if val != v]
        elif t == 1:
            k, v = random.choice(list(provinsi.items()))
            q = f"Ibu kota dari provinsi {k} adalah..."
            wrongs = [val for val in provinsi.values() if val != v]
        else:
            k, v = random.choice(list(pahlawan.items()))
            q = f"Pahlawan nasional {k} berasal dari daerah..."
            wrongs = [val for val in pahlawan.values() if val != v]
            
        random.shuffle(wrongs)
        docs.append(build_firestore_document(generate_random_id(), part_id, q, v, wrongs[:3]))
    return docs

def generate_ppkn(part_id):
    pancasila = {"Satu": "Bintang", "Dua": "Rantai", "Tiga": "Pohon Beringin", "Empat": "Kepala Banteng", "Lima": "Padi dan Kapas"}
    isi_pancasila = {"Ketuhanan yang Maha Esa": "1", "Kemanusiaan yang Adil dan Beradab": "2", "Persatuan Indonesia": "3", "Kerakyatan yang dipimpin oleh...": "4", "Keadilan sosial bagi...": "5"}
    
    docs = []
    for _ in range(2000):
        t = random.randint(0, 1)
        if t == 0:
            k, v = random.choice(list(pancasila.items()))
            q = f"Sila ke-{k} Pancasila dilambangkan dengan..."
            wrongs = [val for val in pancasila.values() if val != v]
        else:
            k, v = random.choice(list(isi_pancasila.items()))
            q = f"Bunyi sila yang berbunyi '{k}' adalah sila ke-..."
            wrongs = ["1", "2", "3", "4", "5"]
            if v in wrongs: wrongs.remove(v)
            
        random.shuffle(wrongs)
        docs.append(build_firestore_document(generate_random_id(), part_id, q, v, wrongs[:3]))
    return docs

def generate_inggris(part_id):
    vocab = {"Buku": "Book", "Meja": "Table", "Kursi": "Chair", "Pintu": "Door", "Jendela": "Window", "Mobil": "Car", "Rumah": "House", "Pohon": "Tree", "Air": "Water", "Api": "Fire"}
    colors = {"Merah": "Red", "Biru": "Blue", "Hijau": "Green", "Kuning": "Yellow", "Hitam": "Black", "Putih": "White", "Abu-abu": "Gray", "Coklat": "Brown"}
    
    docs = []
    for _ in range(2000):
        t = random.randint(0, 1)
        if t == 0:
            k, v = random.choice(list(vocab.items()))
            q = f"Bahasa Inggris dari kata '{k}' adalah..."
            wrongs = [val for val in vocab.values() if val != v]
        else:
            k, v = random.choice(list(colors.items()))
            q = f"Warna '{k}' dalam bahasa Inggris adalah..."
            wrongs = [val for val in colors.values() if val != v]
            
        random.shuffle(wrongs)
        docs.append(build_firestore_document(generate_random_id(), part_id, q, v, wrongs[:3]))
    return docs

def run():
    print("Generating 14,000 questions...")
    all_docs = []
    all_docs.extend(generate_agama("p1"))
    all_docs.extend(generate_indo("p2"))
    all_docs.extend(generate_math("p3"))
    all_docs.extend(generate_ipa("p4"))
    all_docs.extend(generate_ips("p5"))
    all_docs.extend(generate_ppkn("p6"))
    all_docs.extend(generate_inggris("p7"))
    
    print(f"Total questions generated: {len(all_docs)}")
    
    # Upload in batches of 500
    batch_size = 500
    total_uploaded = 0
    
    for i in range(0, len(all_docs), batch_size):
        batch = all_docs[i:i+batch_size]
        payload = {"writes": batch}
        url = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents:commit"
        
        try:
            res = requests.post(url, json=payload)
            if res.status_code == 200:
                total_uploaded += len(batch)
                print(f"Successfully uploaded batch. Progress: {total_uploaded}/{len(all_docs)}")
            else:
                print(f"Error uploading batch: {res.text}")
        except Exception as e:
            print(f"Exception: {e}")
            
        time.sleep(0.2)

if __name__ == "__main__":
    run()
