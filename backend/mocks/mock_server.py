from flask import Flask, request

app = Flask(__name__)


@app.route('/vulnerable', methods=['GET'])
def vulnerable_endpoint():
    # Simuliert eine SQL-Fehlermeldung
    if "' OR '1'='1" in request.args.get('id', ''):
        return "SQL syntax error", 200
    return "Safe response", 200


if __name__ == '__main__':
    app.run(port=5001)
