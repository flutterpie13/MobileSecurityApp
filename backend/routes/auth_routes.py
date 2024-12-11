# routes/auth_routes.py
from flask import Blueprint, request, jsonify, make_response, current_app
from models.user import db, User
from flask_bcrypt import Bcrypt
from flask_jwt_extended import create_access_token, set_access_cookies  # JWT importieren
from app import limiter
import re


auth_blueprint = Blueprint('auth', __name__)
bcrypt = Bcrypt()


@auth_blueprint.route('/register', methods=['POST'])
def register():
    """Registriert einen neuen Benutzer."""
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')
    accept_terms = data.get('accept_terms')
    over_18 = data.get('over_18')

    # Überprüfen, ob die E-Mail bereits existiert
    if User.query.filter_by(email=email).first():
        return jsonify({'message': 'Email already registered.'}), 400
    current_app.logger.info(f"New user registration: {email}")
    # Überprüfen, ob das Passwort stark genug ist
    if not is_strong_password(password):
        return jsonify({'message': 'Password must be at least 8 characters long and include uppercase, lowercase, a number, and a special character.'}), 400

    # Überprüfen, ob die Nutzungsbedingungen und die Volljährigkeit akzeptiert wurden
    if not accept_terms or not over_18:
        return jsonify({'message': 'You must accept the terms and be over 18 to register.'}), 400

    # Passwort hashen und neuen Benutzer erstellen
    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    new_user = User(email=email, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully.'}), 201


@auth_blueprint.route('/login', methods=['POST'])
# Hier wird die limiter-Instanz verwendet, nicht Limiter selbst.
@limiter.limit("5 per minute")
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    user = User.query.filter_by(email=email).first()

    if not user or not bcrypt.check_password_hash(user.password, password):
        current_app.logger.warning(f"Invalid login attempt for email: {email}")
        return jsonify({'message': 'Invalid credentials.'}), 401

    access_token = create_access_token(identity=email)
    response = make_response(jsonify({
        'message': 'Login successful.',
        'user_id': user.id
    }), 200)
    set_access_cookies(response, access_token)
    return response


def is_strong_password(password):
    if len(password) < 8:
        return False
    if not re.search(r'[A-Z]', password):  # Mindestens ein Großbuchstabe
        return False
    if not re.search(r'[a-z]', password):  # Mindestens ein Kleinbuchstabe
        return False
    if not re.search(r'[0-9]', password):  # Mindestens eine Zahl
        return False
    if not re.search(r'[@$!%*?&]', password):  # Mindestens ein Sonderzeichen
        return False
    return True
