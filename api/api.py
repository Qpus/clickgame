from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
import logging

app = Flask(__name__)
CORS(app)  # This will enable CORS for all routes

# Initialize SQLite database
def init_db():
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    cursor.execute('''
    DROP TABLE IF EXISTS scores
    ''')
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS scores (
        id INTEGER PRIMARY KEY,
        player_name TEXT,
        score INTEGER,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    ''')
    conn.commit()
    conn.close()

@app.route('/score', methods=['POST'])
def add_score():
    try:
        player_name = request.json.get('player_name')
        score = request.json.get('score')
        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()
        cursor.execute('INSERT INTO scores (player_name, score) VALUES (?, ?)', (player_name, score))
        conn.commit()
        conn.close()
        return jsonify({'message': 'Score added!'}), 201
    except Exception as e:
        logging.error("Error adding score: %s", e)
        return jsonify({'error': str(e)}), 500

@app.route('/scores', methods=['GET'])
def get_scores():
    try:
        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()
        cursor.execute('SELECT player_name, score, timestamp FROM scores ORDER BY score DESC LIMIT 10')
        scores = cursor.fetchall()
        conn.close()
        return jsonify(scores), 200
    except Exception as e:
        logging.error("Error fetching scores: %s", e)
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    init_db()
    app.run(host='0.0.0.0', port=5000)
