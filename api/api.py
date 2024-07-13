from flask import Flask, request, jsonify
import sqlite3
import time

app = Flask(__name__)

# Initialize SQLite database
def init_db():
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS scores (
        id INTEGER PRIMARY KEY,
        score INTEGER,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    ''')
    conn.commit()
    conn.close()

@app.route('/score', methods=['POST'])
def add_score():
    score = request.json.get('score')
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    cursor.execute('INSERT INTO scores (score) VALUES (?)', (score,))
    conn.commit()
    conn.close()
    return jsonify({'message': 'Score added!'}), 201

@app.route('/scores', methods=['GET'])
def get_scores():
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM scores ORDER BY score DESC LIMIT 10')
    scores = cursor.fetchall()
    conn.close()
    return jsonify(scores), 200

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000)
