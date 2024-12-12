# routes/auth_routes.py
from flask_jwt_extended import jwt_required, get_jwt_identity
from flask import Blueprint, request, jsonify, make_response, current_app
from models.user import db, User
from flask_bcrypt import Bcrypt
from flask_jwt_extended import create_access_token, set_access_cookies  # JWT importieren
from app import limiter, db
import re


auth_blueprint = Blueprint('auth', __name__)
bcrypt = Bcrypt()


def is_strong_password(password):
    if len(password) < 8:
        return False, "Password must be at least 8 characters long."
    if not re.search(r'[A-Z]', password):
        return False, "Password must contain at least one uppercase letter."
    if not re.search(r'[a-z]', password):
        return False, "Password must contain at least one lowercase letter."
    if not re.search(r'[0-9]', password):
        return False, "Password must contain at least one number."
    if not re.search(r'[^a-zA-Z0-9]', password):
        return False, "Password must contain at least one special character."

    return True, "Password is strong."


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
    is_strong, message = is_strong_password(password)
    if not is_strong:
        return jsonify({'message': message}), 400

    # Überprüfen, ob die Nutzungsbedingungen und die Volljährigkeit akzeptiert wurden
    if not accept_terms or not over_18:
        return jsonify({'message': 'You must accept the terms and be over 18 to register.'}), 400

    # Passwort hashen und neuen Benutzer erstellen
    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    new_user = User(
        email=email,
        password=hashed_password,
        accepted_terms=accept_terms,
        over18=over_18
    )
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully.', 'user_id': new_user.id}), 200


@auth_blueprint.route('/login', methods=['POST'])
# Hier wird die limiter-Instanz verwendet, nicht Limiter selbst.
@limiter.limit("5 per minute")
def login():
    """Loggt einen Benutzer ein."""
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
        'user_id': user.id, 'access_token': access_token
    }))
    set_access_cookies(response, access_token)
    return response, 200


@auth_blueprint.route('/')
def auth_index():
    return jsonify({"message": "Auth endpoint is working!"})


@auth_blueprint.route('')
def auth_index_no_slash():
    return jsonify({"message": "Auth endpoint without slash works!"})


@auth_blueprint.route('/profile', methods=['GET'])
@jwt_required()
def profile():
    """Gibt das Profil des aktuellen Benutzers zurück."""

    email = get_jwt_identity()
    user = User.query.filter_by(email=email).first()
    if not user:
        return jsonify({'message': 'User not found.'}), 404

    return jsonify({
        'email': user.email,
        'over18': user.over18,
        'accepted_terms': user.accepted_terms,
        'created_at': user.created_at
    }), 200
