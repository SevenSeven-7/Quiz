import json
import random

print("Membuat database soal Bahasa Indonesia yang unik...")

# Soal-soal unik yang bervariasi
unique_questions_base = [
    # Ejaan dan Penulisan (150 soal)
    {"text": "Penulisan singkatan yang benar adalah?", "options": ["Dr.", "Dr", "DR.", "dr"], "correct": 0, "answer": "Dr."},
    {"text": "Penulisan gelar yang benar adalah?", "options": ["S.Pd", "S.Pd.", "SPd", "s.pd"], "correct": 1, "answer": "S.Pd."},
    {"text": "Kata baku dari 'ijin' adalah?", "options": ["Ijin", "Izin", "Ijien", "Izien"], "correct": 1, "answer": "Izin"},
    {"text": "Kata baku dari 'rubah' (berubah) adalah?", "options": ["Rubah", "Ubah", "Robah", "Rubha"], "correct": 1, "answer": "Ubah"},
    {"text": "Kata baku dari 'jaman' adalah?", "options": ["Jaman", "Zaman", "Jamen", "Zamen"], "correct": 1, "answer": "Zaman"},
    {"text": "Kata baku dari 'resiko' adalah?", "options": ["Resiko", "Risiko", "Resikho", "Risikho"], "correct": 1, "answer": "Risiko"},
    {"text": "Kata baku dari 'tehnik' adalah?", "options": ["Tehnik", "Teknik", "Tekhnik", "Tehniq"], "correct": 1, "answer": "Teknik"},
    {"text": "Kata baku dari 'obyek' adalah?", "options": ["Obyek", "Objek", "Obyeq", "Objeq"], "correct": 1, "answer": "Objek"},
    {"text": "Kata baku dari 'subyek' adalah?", "options": ["Subyek", "Subjek", "Subyeq", "Subjeq"], "correct": 1, "answer": "Subjek"},
    {"text": "Kata baku dari 'kwantitas' adalah?", "options": ["Kwantitas", "Kuantitas", "Quantitas", "Kwantitaz"], "correct": 1, "answer": "Kuantitas"},
    {"text": "Kata baku dari 'kwalitas' adalah?", "options": ["Kwalitas", "Kualitas", "Qualitas", "Kwalitaz"], "correct": 1, "answer": "Kualitas"},
    {"text": "Kata baku dari 'standart' adalah?", "options": ["Standart", "Standar", "Standard", "Standaard"], "correct": 1, "answer": "Standar"},
    {"text": "Kata baku dari 'propinsi' adalah?", "options": ["Propinsi", "Provinsi", "Propvinsi", "Provinci"], "correct": 1, "answer": "Provinsi"},
    {"text": "Kata baku dari 'katagori' adalah?", "options": ["Katagori", "Kategori", "Catagori", "Categori"], "correct": 1, "answer": "Kategori"},
    {"text": "Kata baku dari 'methode' adalah?", "options": ["Methode", "Metode", "Method", "Metod"], "correct": 1, "answer": "Metode"},
    {"text": "Kata baku dari 'photo' adalah?", "options": ["Photo", "Foto", "Poto", "Phot"], "correct": 1, "answer": "Foto"},
    {"text": "Kata baku dari 'physik' adalah?", "options": ["Physik", "Fisik", "Fisika", "Physika"], "correct": 1, "answer": "Fisik"},
    {"text": "Kata baku dari 'theori' adalah?", "options": ["Theori", "Teori", "Theory", "Teory"], "correct": 1, "answer": "Teori"},
    {"text": "Kata baku dari 'hypothesa' adalah?", "options": ["Hypothesa", "Hipotesa", "Hipotesis", "Hypothesis"], "correct": 2, "answer": "Hipotesis"},
    {"text": "Kata baku dari 'diagnosa' adalah?", "options": ["Diagnosa", "Diagnosis", "Diagnose", "Diagnoze"], "correct": 1, "answer": "Diagnosis"},
    {"text": "Kata baku dari 'sistim' adalah?", "options": ["Sistim", "Sistem", "System", "Sisthim"], "correct": 1, "answer": "Sistem"},
    {"text": "Kata baku dari 'nasehat' adalah?", "options": ["Nasehat", "Nasihat", "Nasehad", "Nasihad"], "correct": 1, "answer": "Nasihat"},
    {"text": "Kata baku dari 'praktek' adalah?", "options": ["Praktek", "Praktik", "Praktiek", "Prakthik"], "correct": 1, "answer": "Praktik"},
    {"text": "Kata baku dari 'apotik' adalah?", "options": ["Apotik", "Apotek", "Apothek", "Apothik"], "correct": 1, "answer": "Apotek"},
    {"text": "Kata baku dari 'atlit' adalah?", "options": ["Atlit", "Atlet", "Athlet", "Athleth"], "correct": 1, "answer": "Atlet"},
]
