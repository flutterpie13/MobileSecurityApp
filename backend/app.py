import argparse
from models import db  # Datenbankmodell
import os
from flask import request
# from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_cors import CORS
from flask_migrate import Migrate
from logging.handlers import RotatingFileHandler
import logging
from app import create_app, db


# Flask-App erstellen
app = create_app()
CORS(app, supports_credentials=True)

# Konfiguration aus Umgebungsvariablen oder Fallbacks laden
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'your_fallback_secret_key')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv(
    'DATABASE_URL', 'sqlite:///database.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = os.getenv('JWT_SECRET_KEY', 'fallback_jwt_key')
app.config['JWT_TOKEN_LOCATION'] = ['headers']
app.config['JWT_COOKIE_SECURE'] = False  # In Produktion auf True setzen
app.config['JWT_COOKIE_CSRF_PROTECT'] = True
app.config['JWT_ACCESS_COOKIE_NAME'] = 'access_token_cookie'
app.config['JWT_REFRESH_COOKIE_NAME'] = 'refresh_token_cookie'

# Initialisierung von Modulen
jwt = JWTManager(app)

migrate = Migrate(app, db)

# Ratenbegrenzung mit Redis
limiter = Limiter(
    get_remote_address,
    app=app,
    storage_uri="redis://localhost:6379",  # Redis verwenden
    default_limits=["200 per day", "50 per hour"]
)

# Sicherheitsheader hinzufügen


@app.after_request
def add_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    response.headers['Content-Security-Policy'] = "default-src 'self'; script-src 'self'; style-src 'self';"
    return response


# Logging konfigurieren
logger = logging.getLogger('mobile_security_app')
logger.setLevel(logging.INFO)
handler = RotatingFileHandler('app.log', maxBytes=100000, backupCount=3)
formatter = logging.Formatter(
    '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]')
handler.setFormatter(formatter)
logger.addHandler(handler)


@app.before_request
def log_request_info():
    logger.info(
        f"Request: {request.method} {request.path} from {request.remote_addr}")


# Datenbank beim Start initialisieren
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Run the Flask app.")
    parser.add_argument("--host", default="0.0.0.0",
                        help="Host to run the app on")
    parser.add_argument("--port", type=int, default=8000,
                        help="Port to run the app on")
    args = parser.parse_args()
    with app.app_context():

        db.create_all()
        print("Datenbank und Tabellen erfolgreich erstellt.")

# app.run(debug=False) for production

    app.run(host=args.host, port=args.port, debug=False)
