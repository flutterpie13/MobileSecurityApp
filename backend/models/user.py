from . import db


class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    # agreements = db.relationship('Agreement', backref='user', lazy=True)
    over18 = db.Column(db.Boolean, nullable=False, default=False)
    accepted_terms = db.Column(db.Boolean, nullable=False, default=False)

    def __repr__(self):
        return f"<User {self.email}>"
