import json

# Baca file database
with open('c:\\laragon\\www\\Quiz\\Quiz_Dataset\\database-bahasaindonesia.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Total soal: {len(data)}")

# Hitung kombinasi unik
seen = {}
for item in data:
    key = (item['text'], item['correctAnswer'])
    seen[key] = seen.get(key, 0) + 1

unique_combos = len(seen)
duplicates = sum(1 for v in seen.values() if v > 1)

print(f"Kombinasi soal+jawaban unik: {unique_combos}")
print(f"Kombinasi yang memiliki duplikasi: {duplicates}")

# Tampilkan contoh soal
print("\nContoh 10 soal pertama:")
for i in range(10):
    print(f"{i+1}. [{data[i]['id']}] {data[i]['text']}")
    print(f"   Jawaban: {data[i]['correctAnswer']}")
    print()
