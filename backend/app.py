from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from models import db  # Hier ist db bereits definiert
from routes.auth_routes import auth_blueprint
from routes.scan_routes import scan_blueprint
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
import logging
from logging.handlers import RotatingFileHandler


app = Flask(__name__)

# App Configuration
app.config['SECRET_KEY'] = 'your_secret_key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# JWT-Konfiguration für Cookie-basierten Auth mit CSRF-Schutz
app.config['JWT_SECRET_KEY'] = 'dein-very-secret-key'
app.config['JWT_TOKEN_LOCATION'] = ['cookies']
# In Produktion auf True setzen (HTTPS verwenden!)
app.config['JWT_COOKIE_SECURE'] = False
app.config['JWT_COOKIE_CSRF_PROTECT'] = True
app.config['JWT_ACCESS_COOKIE_NAME'] = 'access_token_cookie'
app.config['JWT_REFRESH_COOKIE_NAME'] = 'refresh_token_cookie'
jwt = JWTManager(app)

# Initialize the database
db.init_app(app)

# Register Blueprints
app.register_blueprint(auth_blueprint, url_prefix='/auth')
app.register_blueprint(scan_blueprint, url_prefix='/scan')


@app.after_request
def add_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    # Content-Security-Policy anpassen, je nach Bedarf (hier sehr restriktiv als Beispiel)
    response.headers['Content-Security-Policy'] = "default-src 'self'; script-src 'self'; style-src 'self';"
    return response


limiter = Limiter(
    get_remote_address,
    app=app,
    default_limits=["200 per day", "50 per hour"]

)
logger = logging.getLogger('mobile_security_app')
logger.setLevel(logging.INFO)

# Rotierender File-Handler, um Logfiles unter Kontrolle zu halten
handler = RotatingFileHandler('app.log', maxBytes=100000, backupCount=3)
formatter = logging.Formatter(
    '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]')
handler.setFormatter(formatter)
logger.addHandler(handler)


@app.before_request
def log_request_info():
    logger.info(
        f"Request: {request.method} {request.path} from {request.remote_addr}")


if __name__ == '__main__':
    with app.app_context():
        db.create_all()  # Hier wird die Datenbank erstellt
        print("Datenbank und Tabellen erfolgreich erstellt.")
    app.run(debug=True)
