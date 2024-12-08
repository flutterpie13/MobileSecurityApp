from flask import Flask
from models import db
from flask_sqlalchemy import SQLAlchemy
from routes.auth_routes import auth_blueprint
from routes.scan_routes import scan_blueprint
from models.user import db  # Importiere die Datenbank

app = Flask(__name__)

# App Configuration
app.config['SECRET_KEY'] = 'your_secret_key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize the database
db.init_app(app)

# Register Blueprints
app.register_blueprint(auth_blueprint, url_prefix='/auth')
app.register_blueprint(scan_blueprint, url_prefix='/scan')

if __name__ == '__main__':
    with app.app_context():
        db.create_all()  # Hier wird die Datenbank erstellt
        print("Datenbank und Tabellen erfolgreich erstellt.")
    app.run(debug=True)
