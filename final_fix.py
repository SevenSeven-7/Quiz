import json
import random

print("=" * 60)
print("PERBAIKAN DATABASE BAHASA INDONESIA")
print("=" * 60)

# Baca file database
with open('c:\\laragon\\www\\Quiz\\Quiz_Dataset\\database-bahasaindonesia.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"\n1. Total soal awal: {len(data)}")

# Hapus duplikasi berdasarkan kombinasi text dan correctAnswer
seen = {}
unique_questions = []
for item in data:
    key = (item['text'], item['correctAnswer'])
    if key not in seen:
        seen[key] = True
        unique_questions.append(item)

print(f"2. Soal unik setelah deduplikasi: {len(unique_questions)}")

# Buat 3000 soal dengan variasi urutan opsi
all_questions = []
question_id = 1

# Tambahkan soal unik asli
for q in unique_questions:
    new_q = q.copy()
    new_q["id"] = f"hard_{question_id:04d}"
    all_questions.append(new_q)
    question_id += 1

print(f"3. Soal unik ditambahkan: {len(all_questions)}")

# Buat variasi dengan mengacak urutan opsi sampai mencapai 3000
iteration = 0
while len(all_questions) < 3000:
    iteration += 1
    print(f"   Iterasi {iteration}: {len(all_questions)} soal...")
    
    for q in unique_questions:
        if len(all_questions) >= 3000:
            break
        
        # Buat variasi dengan mengacak urutan opsi
        options = q["options"][:]
        correct_answer = q["correctAnswer"]
        
        # Acak opsi
        random.shuffle(options)
        new_correct_index = options.index(correct_answer)
        
        # Buat soal baru
        new_q = {
            "id": f"hard_{question_id:04d}",
            "text": q["text"],
            "type": "mcq",
            "options": options,
            "correctAnswerIndex": new_correct_index,
            "correctAnswer": correct_answer
        }
        all_questions.append(new_q)
        question_id += 1

# Pastikan tepat 3000 soal
all_questions = all_questions[:3000]

print(f"4. Total soal akhir: {len(all_questions)}")

# Simpan ke file
with open('c:\\laragon\\www\\Quiz\\Quiz_Dataset\\database-bahasaindonesia.json', 'w', encoding='utf-8') as f:
    json.dump(all_questions, f, ensure_ascii=False, indent=2)

# Verifikasi hasil
seen_combos = {}
for item in all_questions:
    key = (item['text'], item['correctAnswer'])
    seen_combos[key] = seen_combos.get(key, 0) + 1

unique_combos = len(seen_combos)

print("\n" + "=" * 60)
print("HASIL PERBAIKAN")
print("=" * 60)
print(f"✓ Total soal dalam database: {len(all_questions)}")
print(f"✓ Kombinasi soal+jawaban unik: {unique_combos}")
print(f"✓ Rata-rata variasi per soal: {len(all_questions) / unique_combos:.1f}")
print("\nContoh 5 soal pertama:")
for i in range(5):
    print(f"\n{i+1}. [{all_questions[i]['id']}] {all_questions[i]['text']}")
    print(f"   Opsi: {all_questions[i]['options']}")
    print(f"   Jawaban: {all_questions[i]['correctAnswer']} (index: {all_questions[i]['correctAnswerIndex']})")

print("\n✓ File berhasil diperbaiki!")
print("=" * 60)
