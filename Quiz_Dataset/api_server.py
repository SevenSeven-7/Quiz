"""
Quiz Dataset API Server
Menyediakan REST API untuk mengakses database soal quiz
Database terpisah per mata pelajaran (7 file JSON)
"""

from flask import Flask, jsonify, request
from flask_cors import CORS
import json
import random
import os

app = Flask(__name__)
CORS(app)  # Enable CORS untuk Flutter web

# Mapping subject ID ke file database
DATABASE_FILES = {
    'p1': 'database-agamaislam.json',
    'p2': 'database-bahasaindonesia.json',
    'p3': 'database-matematika.json',
    'p4': 'database-ilmupengetahuanalam.json',
    'p5': 'database-ilmupengetahuansosial.json',
    'p6': 'database-ppkn.json',
    'p7': 'database-bahasainggris.json',
}

# Metadata subjects
SUBJECTS = {
    "p1": {"id": "p1", "name": "Agama Islam", "description": "Pelajari rukun iman, shalat, dan nabi"},
    "p2": {"id": "p2", "name": "Bahasa Indonesia", "description": "Tata bahasa, EYD, dan kosa kata"},
    "p3": {"id": "p3", "name": "Matematika", "description": "Logika berhitung, aljabar, dan angka"},
    "p4": {"id": "p4", "name": "Ilmu Pengetahuan Alam", "description": "Fisika, biologi, dan alam semesta"},
    "p5": {"id": "p5", "name": "Ilmu Pengetahuan Sosial", "description": "Sejarah pahlawan, dan geografi"},
    "p6": {"id": "p6", "name": "PPKn", "description": "Pancasila, UUD 1945, dan negara"},
    "p7": {"id": "p7", "name": "Bahasa Inggris", "description": "Vocabulary, grammar, dan dasar"},
}

def load_questions(subject_id):
    """Load questions dari file JSON untuk subject tertentu"""
    if subject_id not in DATABASE_FILES:
        return []
    
    file_path = os.path.join(os.path.dirname(__file__), DATABASE_FILES[subject_id])
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        return []

def get_total_questions():
    """Hitung total semua soal"""
    total = 0
    for subject_id in DATABASE_FILES.keys():
        questions = load_questions(subject_id)
        total += len(questions)
    return total

@app.route('/')
def home():
    """Homepage API"""
    return jsonify({
        "status": "success",
        "message": "Quiz Dataset API Server",
        "version": "1.0.0",
        "endpoints": {
            "GET /subjects": "Get all subjects",
            "GET /questions/<subject_id>": "Get random 10 questions for a subject",
            "GET /questions/<subject_id>/all": "Get all questions for a subject",
            "POST /questions/<subject_id>": "Add new question",
            "GET /health": "Health check"
        }
    })

@app.route('/health')
def health():
    """Health check endpoint"""
    total_questions = get_total_questions()
    
    return jsonify({
        "status": "healthy",
        "database": "connected",
        "total_questions": total_questions,
        "subjects": len(SUBJECTS)
    })

@app.route('/subjects')
def get_subjects():
    """Get all subjects"""
    return jsonify({
        "status": "success",
        "data": list(SUBJECTS.values())
    })

@app.route('/questions/<subject_id>')
def get_random_questions(subject_id):
    """Get 10 random questions for a subject"""
    all_questions = load_questions(subject_id)
    
    if not all_questions:
        return jsonify({
            "status": "error",
            "message": f"No questions found for subject {subject_id}"
        }), 404
    
    # Get random 10 questions
    random_questions = random.sample(all_questions, min(10, len(all_questions)))
    
    # Shuffle options for each MCQ question
    for question in random_questions:
        if question.get('type') == 'mcq' and question.get('options'):
            options = question['options'].copy()
            correct_answer = options[question['correctAnswerIndex']]
            random.shuffle(options)
            question['options'] = options
            question['correctAnswerIndex'] = options.index(correct_answer)
    
    return jsonify({
        "status": "success",
        "subject_id": subject_id,
        "count": len(random_questions),
        "data": random_questions
    })

@app.route('/questions/<subject_id>/all')
def get_all_questions(subject_id):
    """Get all questions for a subject"""
    all_questions = load_questions(subject_id)
    
    return jsonify({
        "status": "success",
        "subject_id": subject_id,
        "count": len(all_questions),
        "data": all_questions
    })

@app.route('/stats')
def get_stats():
    """Get database statistics"""
    stats = {
        "total_subjects": len(SUBJECTS),
        "total_questions": 0,
        "questions_per_subject": {}
    }
    
    for subject_id in DATABASE_FILES.keys():
        questions = load_questions(subject_id)
        count = len(questions)
        stats['questions_per_subject'][subject_id] = count
        stats['total_questions'] += count
    
    return jsonify({
        "status": "success",
        "data": stats
    })

if __name__ == '__main__':
    print("=" * 50)
    print("🚀 Quiz Dataset API Server")
    print("=" * 50)
    print("📊 Server running on: http://localhost:5000")
    print("📚 Database: 7 file JSON terpisah per mapel")
    print("📝 Endpoints:")
    print("   - GET  /subjects")
    print("   - GET  /questions/<subject_id>")
    print("   - GET  /questions/<subject_id>/all")
    print("   - GET  /stats")
    print("   - GET  /health")
    print("=" * 50)
    
    app.run(host='0.0.0.0', port=5000, debug=True)
