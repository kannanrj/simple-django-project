from flask import Flask, request
from datetime import datetime
import json

app = Flask(__name__)

@app.route('/')
def get_time_ip():
    x_forwarded_for = request.headers.get('X-Forwarded-For')
    if x_forwarded_for:
        client_ip = x_forwarded_for.split(',')[0].strip()
    else:
        client_ip = request.remote_addr

    response = {
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "ip": client_ip
    }

    return json.dumps(response), 200, {'Content-Type': 'application/json'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
