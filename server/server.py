from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

@app.route('/', methods=['GET'])
def home():
    return "Server is running!"

@app.route('/command', methods=['POST', 'OPTIONS'])
def handle_command():
    if request.method == 'OPTIONS':
        response = jsonify({'status': 'ok'})
        response.headers.add('Access-Control-Allow-Headers', 'Content-Type')
        response.headers.add('Access-Control-Allow-Methods', 'POST')
        return response

    command = request.form.get('command')
    degree = request.form.get('degree', '')
    print(f"Received command: {command}, Degree: {degree}")
    
    command_messages = {
        'tl': 'Temperature Left ON',
        'TL': 'Temperature Left OFF',
        'tr': 'Temperature Right ON',
        'TR': 'Temperature Right OFF',
        'tb': 'Temperature Both ON',
        'TB': 'Temperature Both OFF',
        'vl': 'Vibration Left ON',
        'VL': 'Vibration Left OFF',
        'vr': 'Vibration Right ON',
        'VR': 'Vibration Right OFF',
        'vb': 'Vibration Both ON',
        'VB': 'Vibration Both OFF'
    }
    
    if command in command_messages:
        print(f"{command_messages[command]} with degree: {degree}")
    
    return jsonify({
        "status": "success", 
        "command": command,
        "degree": degree
    })


if __name__ == '__main__':
    # Enable debug mode and listen on all interfaces
    app.run(host='0.0.0.0', port=5000, debug=True)