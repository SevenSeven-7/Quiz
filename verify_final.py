import json

# Baca file database
with open('c:\\laragon\\www\\Quiz\\Quiz_Dataset\\database-bahasaindonesia.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print("=" * 70)
print("VERIFIKASI AKHIR DATABASE BAHASA INDONESIA")
print("=" * 70)

# Statistik dasar
print(f"\n📊 STATISTIK DASAR:")
print(f"   Total soal: {len(data)}")

# Hitung kombinasi unik
seen = {}
for item in data:
    key = (item['text'], item['correctAnswer'])
    seen[key] = seen.get(key, 0) + 1

unique_combos = len(seen)
print(f"   Kombinasi soal+jawaban unik: {unique_combos}")
print(f"   Rata-rata variasi per soal: {len(data) / unique_combos:.1f}x")

# Tampilkan daftar soal unik
print(f"\n📝 DAFTAR {unique_combos} SOAL UNIK:")
print("-" * 70)
for i, (key, count) in enumerate(seen.items(), 1):
    text, answer = key
    print(f"{i:2d}. {text}")
    print(f"    Jawaban: {answer} | Variasi: {count}x")
    print()

# Cek ID unik
ids = [item['id'] for item in data]
unique_ids = len(set(ids))
print(f"\n🔍 VALIDASI:")
print(f"   Total ID: {len(ids)}")
print(f"   ID unik: {unique_ids}")
print(f"   Status: {'✓ VALID' if len(ids) == unique_ids else '✗ ADA DUPLIKASI ID'}")

# Cek format
print(f"\n📋 FORMAT:")
all_valid = True
for item in data[:5]:  # Cek 5 soal pertama
    if not all(k in item for k in ['id', 'text', 'type', 'options', 'correctAnswerIndex', 'correctAnswer']):
        all_valid = False
        break
print(f"   Status: {'✓ FORMAT VALID' if all_valid else '✗ FORMAT TIDAK VALID'}")

print("\n" + "=" * 70)
print("✓ VERIFIKASI SELESAI")
print("=" * 70)
