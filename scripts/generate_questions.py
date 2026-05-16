import json
import random

def generate_sample_questions(part_id, num_levels=100):
    levels = []
    
    subjects = {
        "p1": ["Bahasa Indonesia", "Kosa Kata", "Tata Bahasa", "Sastra"],
        "p2": ["Matematika", "Aljabar", "Geometri", "Aritmatika"]
    }
    
    for i in range(1, num_levels + 1):
        questions = []
        for q_idx in range(1, 11):
            q_id = f"{part_id}_l{i}_q{q_idx}"
            is_essay = q_idx in [5, 10]
            
            if part_id == "p1":
                if is_essay:
                    text = f"Level {i}: Sebutkan satu kata benda yang berkaitan dengan {random.choice(subjects[part_id])}!"
                    answer = "contoh"
                else:
                    words = ['Cepat', 'Lambat', 'Pintar', 'Rajin', 'Gembira', 'Sedih']
                    word = random.choice(words)
                    text = f"Level {i}: Apa sinonim yang tepat untuk kata '{word}'?"
                    options = ["Jawaban Benar", "Pilihan Salah 1", "Pilihan Salah 2", "Pilihan Salah 3"]
                    random.shuffle(options)
                    answer_idx = options.index("Jawaban Benar")
            else:
                if is_essay:
                    a, b = random.randint(1, 50), random.randint(1, 50)
                    text = f"Level {i}: Berapakah hasil dari {a} + {b}?"
                    answer = str(a + b)
                else:
                    a, b = random.randint(1, 10), random.randint(1, 10)
                    text = f"Level {i}: Berapakah hasil dari {a} x {b}?"
                    options = [str(a*b), str(a*b + 1), str(a*b - 1), str(a*b + 2)]
                    random.shuffle(options)
                    answer_idx = options.index(str(a*b))
            
            if is_essay:
                questions.append({
                    "id": q_id,
                    "type": "essay",
                    "text": text,
                    "correctAnswer": answer
                })
            else:
                questions.append({
                    "id": q_id,
                    "type": "mcq",
                    "text": text,
                    "options": options,
                    "correctAnswerIndex": answer_idx
                })
                
        levels.append({
            "id": f"{part_id}_l{i}",
            "partId": part_id,
            "order": i,
            "questions": questions
        })
    return levels

data = {
    "parts": [
        {
            "id": "p1",
            "title": "Bagian 1: Quiz Bahasa Indonesia",
            "description": "Uji kemampuan tata bahasa dan kosa kata Bahasa Indonesia Anda.",
            "isLocked": False
        },
        {
            "id": "p2",
            "title": "Bagian 2: Quiz Matematika",
            "description": "Tantangan logika dan angka untuk mengasah otak.",
            "isLocked": True
        }
    ],
    "levels": generate_sample_questions("p1") + generate_sample_questions("p2")
}

with open('assets/data/questions.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print("Berhasil men-generate 2000 soal (template) ke assets/data/questions.json")
