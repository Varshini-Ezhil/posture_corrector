from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Store the latest value in memory
latest_value = None

@app.route('/', methods=['GET'])
def home():
    # Display the server status along with the latest value
    return f"""
    <html>
        <head><title>Posture Corrector</title></head>
        <body>
            <h1>Server is running!</h1>
            
        </body>
    </html>
    """

@app.route('/api', methods=['POST', 'GET'])
def receive_value():
    global latest_value

    if request.method == 'POST':
        # Handle POST request
        value = request.form.get('value')  # Get the 'value' from the POST request
        degree = request.form.get('degree')  # Get the 'degree' from the POST request
        if value and degree:
            latest_value = {'value': value, 'degree': degree}
            print(f"Received value: {value}, degree: {degree}")
            return jsonify({'status': 'success', 'message': f'Value {value} and degree {degree} received'}), 200
        elif value:
            latest_value = {'value': value}
            print(f"Received value: {value}")
            return jsonify({'status': 'success', 'message': f'Value {value} received'}), 200
        else:
            return jsonify({'status': 'error', 'message': 'No value or degree received'}), 400

    elif request.method == 'GET':
        # Handle GET request
        if latest_value:
            return jsonify({'status': 'success', 'data': latest_value}), 200
        else:
            return jsonify({'status': 'error', 'message': 'No value available'}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)