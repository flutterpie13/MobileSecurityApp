from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from redis import Redis

# Initialisierungen
db = SQLAlchemy()
jwt = JWTManager()
redis_client = Redis(host="localhost", port=6379)

limiter = Limiter(
    get_remote_address,
    default_limits=["200 per day", "50 per hour"],
    storage_uri="redis://localhost:6379"
)


def create_app():
    app = Flask(__name__)
    app.url_map.strict_slashes = False
    # Konfiguration von Flask
    # Passe den Pfad an, falls nötig
    app.config.from_pyfile("config.py", silent=True)
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    # Initialisierung von Modulen
    db.init_app(app)
    jwt.init_app(app)
    limiter.init_app(app)

    # Importiere und registriere Blueprints
    from routes.auth_routes import auth_blueprint
    from routes.scan_routes import scan_blueprint
    app.register_blueprint(auth_blueprint, url_prefix='/auth')
    app.register_blueprint(scan_blueprint, url_prefix='/scan')

    return app
