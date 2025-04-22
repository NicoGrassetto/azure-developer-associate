from flask import Flask, jsonify
import os
import random
import string

app = Flask(__name__)

# Get environment variables with default values if not set
NUM_WORDS = int(os.environ.get('numWords', '3'))
MIN_LENGTH = int(os.environ.get('MinLength', '5'))

def generate_random_word(min_length):
    """Generate a random word with at least min_length characters."""
    word_length = random.randint(min_length, min_length + 5)
    return ''.join(random.choice(string.ascii_lowercase) for _ in range(word_length))

@app.route('/')
def hello_world():
    return 'Hello, Azure Container Registry!'

@app.route('/words')
def random_words():
    """Generate random words based on environment variables."""
    words = [generate_random_word(MIN_LENGTH) for _ in range(NUM_WORDS)]
    return jsonify({
        'words': words,
        'count': NUM_WORDS,
        'min_length': MIN_LENGTH
    })

@app.route('/config')
def show_config():
    """Show the current configuration from environment variables."""
    return jsonify({
        'numWords': NUM_WORDS,
        'MinLength': MIN_LENGTH
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)