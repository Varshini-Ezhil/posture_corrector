from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Store the latest value in memory
latest_value = None

@app.route('/api', methods=['POST', 'GET'])
def receive_value():
    global latest_value

    if request.method == 'POST':
        # Handle POST request
        value = request.form.get('value')  # Get the 'value' from the POST request
        degree = request.form.get('degree')  # Get the 'degree' from the POST request

        if value and degree:
            latest_value = {'command': value, 'degree': int(degree)}
            print(f"Received value: {value}, degree: {degree}")
            return jsonify({'command': value, 'degree': int(degree), 'status': 'success'}), 200
        elif value:
            latest_value = {'command': value}
            print(f"Received value: {value}")
            return jsonify({'command': value, 'status': 'success'}), 200
        else:
            return jsonify({'status': 'error', 'message': 'No value or degree received'}), 400

    elif request.method == 'GET':
        # Handle GET request
        if latest_value:
            # Flatten the response to match the desired format
            response = {
                'command': latest_value.get('command'),
                'degree': latest_value.get('degree'),
                'status': 'success'
            }
            return jsonify(response), 200
        else:
            return jsonify({'status': 'error', 'message': 'No value available'}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)