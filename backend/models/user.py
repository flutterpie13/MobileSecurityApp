from app import db
from flask_bcrypt import Bcrypt
bcrypt = Bcrypt()


class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, default=db.func.now())
    # agreements = db.relationship('Agreement', backref='user', lazy=True)
    over18 = db.Column(db.Boolean, nullable=False, default=False)
    accepted_terms = db.Column(db.Boolean, nullable=False, default=False)

    def __repr__(self):
        return f"<User {self.email}>"

    def set_password(self, raw_password):
        self.password = bcrypt.generate_password_hash(
            raw_password).decode('utf-8')

    def check_password(self, raw_password):
        return bcrypt.check_password_hash(self.password, raw_password)

    def to_json(self):
        return {
            "id": self.id,
            "email": self.email,
            "created_at": self.created_at.isoformat(),
            "over18": self.over18,
            "accepted_terms": self.accepted_terms
        }
