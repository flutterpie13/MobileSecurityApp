from flask import Blueprint, request, jsonify
from models.user import db, User
from flask_bcrypt import Bcrypt

auth_blueprint = Blueprint('auth', __name__)
bcrypt = Bcrypt()


@auth_blueprint.route('/register', methods=['POST'])
def register():
    """Registriert einen neuen Benutzer."""
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    # Überprüfen, ob die E-Mail bereits existiert
    if User.query.filter_by(email=email).first():
        return jsonify({'message': 'Email already registered.'}), 400

    # Passwort hashen und neuen Benutzer erstellen
    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    new_user = User(email=email, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully.'}), 201


@auth_blueprint.route('/login', methods=['POST'])
def login():
    """Authentifiziert einen Benutzer."""
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    user = User.query.filter_by(email=email).first()

    # Benutzer überprüfen
    if not user or not bcrypt.check_password_hash(user.password, password):
        return jsonify({'message': 'Invalid credentials.'}), 401

    return jsonify({'message': 'Login successful.', 'user_id': user.id}), 200
