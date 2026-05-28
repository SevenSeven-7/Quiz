import json
import random

q_list = []
q_texts = set()

def q(text, correct, w1, w2, w3):
    if text in q_texts: return
    q_texts.add(text)
    
    opts = [correct, w1, w2, w3]
    unique_opts = list(set(opts))
            
    while len(unique_opts) < 4:
        val = random.randint(100, 9999)
        suffix = ""
        if "cm²" in correct: suffix = " cm²"
        elif "cm" in correct: suffix = " cm"
        elif "°" in correct: suffix = "°"
        unique_opts.append(f"{val}{suffix}")
        unique_opts = list(set(unique_opts))
        
    random.shuffle(unique_opts)
    q_list.append({
        "text": text,
        "correctAnswer": correct,
        "options": unique_opts,
        "type": "multiple_choice",
        "correctAnswerIndex": unique_opts.index(correct)
    })

# 1. Aljabar: Penjumlahan (x + a = b)
for a in range(1, 30):
    for offset in range(1, 5):
        b = a + offset * 5
        x = b - a
        text = f"Nilai x yang memenuhi persamaan x + {a} = {b} adalah..."
        q(text, str(x), str(x+1), str(x-1), str(x+2))

# 2. Aljabar: Pengurangan (y - a = b)
for a in range(10, 40):
    for offset in range(1, 4):
        b = a + offset * 3
        y = b + a
        text = f"Tentukan nilai y dari persamaan y - {a} = {b}!"
        q(text, str(y), str(y+5), str(y-5), str(y+10))

# 3. Aljabar: Perkalian (a * z = b)
for a in range(2, 20):
    for z in range(2, 10):
        b = a * z
        text = f"Jika {a}z = {b}, maka nilai z adalah..."
        q(text, str(z), str(z+1), str(z-1), str(z+2))

# 4. Aljabar: 2x + a = b
for x in range(2, 15):
    for a in range(1, 10):
        b = 2 * x + a
        text = f"Berapakah nilai x jika 2x + {a} = {b}?"
        q(text, str(x), str(x+2), str(x-1), str(x+3))

# 5. Segitiga: Mencari sudut ketiga
# a + b + c = 180
for a in range(30, 80, 5):
    for b in range(40, 90, 5):
        c = 180 - a - b
        text = f"Sebuah segitiga memiliki dua sudut sebesar {a}° dan {b}°. Berapa besar sudut ketiganya?"
        q(text, f"{c}°", f"{c+10}°", f"{c-10}°", f"{c+5}°")

# 6. Segitiga: Teorema Pythagoras (siku-siku)
pythagorean_triples = [
    (3,4,5), (5,12,13), (8,15,17), (7,24,25), (9,40,41),
    (6,8,10), (10,24,26), (15,20,25), (12,16,20), (18,24,30),
    (14,48,50), (21,28,35), (27,36,45), (16,30,34), (20,21,29)
]
for alas, tinggi, miring in pythagorean_triples:
    text = f"Segitiga siku-siku memiliki alas {alas} cm dan tinggi {tinggi} cm. Panjang sisi miringnya adalah..."
    q(text, f"{miring} cm", f"{miring+1} cm", f"{miring-1} cm", f"{miring+2} cm")
    
    text2 = f"Sisi miring segitiga siku-siku adalah {miring} cm dan salah satu sisi tegaknya {alas} cm. Berapa panjang sisi tegak lainnya?"
    q(text2, f"{tinggi} cm", f"{tinggi+2} cm", f"{tinggi-2} cm", f"{tinggi+3} cm")

# 7. Luas Segitiga (1/2 * alas * tinggi)
for alas in range(4, 20, 2):
    for tinggi in range(5, 25, 2):
        luas = int(0.5 * alas * tinggi)
        text = f"Luas segitiga yang memiliki alas {alas} cm dan tinggi {tinggi} cm adalah..."
        q(text, f"{luas} cm²", f"{luas+5} cm²", f"{luas-5} cm²", f"{luas+10} cm²")

# 8. Keliling Segitiga (a+b+c)
for a in range(10, 20, 2):
    for b in range(11, 21, 2):
        for c in range(12, 22, 3):
            keliling = a + b + c
            text = f"Keliling segitiga dengan panjang sisi {a} cm, {b} cm, dan {c} cm adalah..."
            q(text, f"{keliling} cm", f"{keliling+2} cm", f"{keliling-2} cm", f"{keliling+4} cm")

random.shuffle(q_list)

if len(q_list) > 500:
    q_list = q_list[:500]

for idx, q_obj in enumerate(q_list):
    q_obj['id'] = f"matematika_{idx+1}"

db_path = 'c:/laragon/www/Quiz/assets/datasets/matematika/database-matematika.json'
with open(db_path, 'w', encoding='utf-8') as f:
    json.dump(q_list, f, indent=2, ensure_ascii=False)

print(f"Generated EXACTLY {len(q_list)} unique questions and saved to {db_path}.")
