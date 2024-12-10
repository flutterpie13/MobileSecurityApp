# routes/scan_routes.py

from flask import Blueprint, request, jsonify
from models.scan import db, Scan
import json
from flask_jwt_extended import jwt_required, get_jwt_identity

# Zuerst den Blueprint definieren
scan_blueprint = Blueprint('scan', __name__)


@scan_blueprint.route('/secure-endpoint', methods=['GET'])
@jwt_required()
def secure_endpoint():
    current_user = get_jwt_identity()
    # Zugriff auf geschützte Ressourcen oder Daten
    return jsonify(msg=f"Hello, {current_user}. This is a protected endpoint.")


@scan_blueprint.route('/perform', methods=['POST'])
@jwt_required()
def perform_scan():
    data = request.get_json()
    scan_type = data.get('scan_type')
    target = data.get('target')

    # Dummy-Check-Ergebnisse (in der Realität würdest du hier richtige Prüfungen durchführen)
    results = {
        'SQL Injection': 'Pass',
        'XSS': 'Fail',
        'API Security': 'Pass',
        'Authentication': 'Fail',
        'CSRF': 'Pass',
        'Directory Listing': 'Fail'
    }

    new_scan = Scan(scan_type=scan_type, target=target,
                    results=json.dumps(results))
    db.session.add(new_scan)
    db.session.commit()

    return jsonify({'message': 'Scan performed successfully.', 'results': results}), 200

    # Scan-Ergebnisse speichern
    new_scan = Scan(scan_type=scan_type, target=target, results=str(results))
    db.session.add(new_scan)
    db.session.commit()

    return jsonify({'message': 'Scan performed successfully.', 'results': results}), 200


@scan_blueprint.route('/history', methods=['GET'])
@jwt_required()
def scan_history():
    scans = Scan.query.order_by(Scan.created_at.desc()).all()
    history = []
    for s in scans:
        history.append({
            'id': s.id,
            'scan_type': s.scan_type,
            'target': s.target,
            'created_at': s.created_at.isoformat(),
            'results': json.loads(s.results)
        })
    return jsonify(history), 200


@scan_blueprint.route('/results', methods=['GET'])
@jwt_required()
def get_scan_results():
    scan_type = request.args.get('scanType')
    target = request.args.get('target')

    if not scan_type or not target:
        return jsonify({'message': 'scanType and target are required'}), 400

    # Nehmen wir an, wir holen den letzten Scan für diese Kombi
    scan = Scan.query.filter_by(scan_type=scan_type, target=target).order_by(
        Scan.created_at.desc()).first()
    if not scan:
        return jsonify({}), 200  # Keine Daten gefunden

    results = json.loads(scan.results)
    return jsonify(results), 200


@scan_blueprint.route('/details', methods=['GET'])
@jwt_required()
def get_check_details():
    check_name = request.args.get('checkName')
    if not check_name:
        return jsonify({'message': 'checkName is required'}), 400

    # Beispiel: Nimm den letzten Scan (oder definiere genaueren Filter)
    scan = Scan.query.order_by(Scan.created_at.desc()).first()
    if not scan:
        return jsonify({'message': 'No scans available'}), 404

    results = json.loads(scan.results)

    if check_name not in results:
        return jsonify({'message': f'Check {check_name} not found in the latest scan.'}), 404

    status = results[check_name]
    # Empfehlungen könnten kontextabhängig sein, hier ein Dummy:
    recommendations = f'Details and recommendations for {check_name}.'

    return jsonify({
        'status': status,
        'recommendations': recommendations
    }), 200


@scan_blueprint.route('/config-options', methods=['GET'])
@jwt_required()
def config_options():
    # Beispielhafte statische Konfiguration
    options = {
        'availableChecks': [
            'SQL Injection',
            'XSS',
            'API Security',
            'Authentication',
            'CSRF',
            'Directory Listing'
        ]
    }
    return jsonify(options), 200
