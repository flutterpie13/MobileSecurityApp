from flask import Blueprint, request, jsonify
from app.security_checks import check_sql_injection

scan = Blueprint('scan', __name__)


@scan.route('/api/scan/sql_injection', methods=['POST'])
def sql_injection_scan():
    """
    Endpunkt für SQL-Injection-Prüfung.
    """
    data = request.json
    url = data.get("url")

    if not url:
        return jsonify({"error": "URL fehlt"}), 400

    result = check_sql_injection(url)
    return jsonify(result)
