# routes/scan_routes.py

from flask import Blueprint, request, jsonify
from models.scan import db, Scan
from flask_jwt_extended import jwt_required, get_jwt_identity
from schemas.scan_schema import PerformScanSchema

# Zuerst den Blueprint definieren
scan_blueprint = Blueprint('scan', __name__)


@scan_blueprint.route('/secure-endpoint', methods=['GET'])
@jwt_required()
def secure_endpoint():
    current_user = get_jwt_identity()
    # Zugriff auf geschützte Ressourcen oder Daten
    return jsonify(msg=f"Hello, {current_user}. This is a protected endpoint.")


@scan_blueprint.route('/perform', methods=['POST'])
def perform_scan():
    data = request.get_json() or {}

    # Validierung
    schema = PerformScanSchema()
    errors = schema.validate(data)
    if errors:
        return jsonify(errors), 400

    scan_type = data.get('scan_type')
    target = data.get('target')

    # Dummy-Check-Ergebnisse (kann durch tatsächliche Prüfungen ersetzt werden)
    results = {
        'SQL Injection': 'Pass',
        'XSS': 'Fail'
    }

    # Scan-Ergebnisse speichern
    new_scan = Scan(scan_type=scan_type, target=target, results=str(results))
    db.session.add(new_scan)
    db.session.commit()

    return jsonify({'message': 'Scan performed successfully.', 'results': results}), 200


@scan_blueprint.route('/history', methods=['GET'])
def scan_history():
    """Gibt eine Liste aller gespeicherten Scans zurück."""
    scans = Scan.query.all()
    history = [
        {
            'id': scan.id,
            'scan_type': scan.scan_type,
            'target': scan.target,
            'created_at': scan.created_at,
            'results': scan.results
        } for scan in scans
    ]
    return jsonify(history), 200


@scan_blueprint.route('/results', methods=['GET'])
def get_scan_results():
    scan_type = request.args.get('scanType')
    target = request.args.get('target')

    # Beispiel: Suche nach einem Scan in der Datenbank, der zu scanType und target passt
    # Hier musst du deine eigene Logik einbauen, wie du die Daten ablegst und abrufst.
    scan = Scan.query.filter_by(scan_type=scan_type, target=target).first()
    if not scan:
        return jsonify({'message': 'No results found for the given parameters.'}), 404

    # Wenn `scan.results` z. B. ein JSON-String ist, der die Ergebnisse der Checks enthält
    # (etwa {"SQL Injection":"Pass","XSS":"Fail"}), dann dekodiere diesen:
    import json
    results = json.loads(scan.results)

    return jsonify(results), 200
