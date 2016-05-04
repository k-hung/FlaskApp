from flask.ext.sqlalchemy import SQLAlchemy
from werkzeug import generate_password_hash, check_password_hash

db = SQLAlchemy()

class User(db.Model):
  __tablename__ = 'users'
  uid = db.Column(db.Integer, primary_key = True, nullable=False)
  firstname = db.Column(db.String(100), nullable=False)
  lastname = db.Column(db.String(100), nullable=False)
  email = db.Column(db.String(120), unique=True, nullable=False)
  pwdhash = db.Column(db.String(54), nullable=False)

  def __init__(self, firstname, lastname, email, password):
    self.firstname = firstname.title()
    self.lastname = lastname.title()
    self.email = email.lower()
    self.set_password(password)

  def set_password(self, password):
    self.pwdhash = generate_password_hash(password)

  def check_password(self, password):
    return check_password_hash(self.pwdhash, password)

class Category1(db.Model):
  __tablename__ = 'c1'
  c1_name = db.Column(db.String(45), primary_key = True, nullable=False)


  def __init__(self, firstname, lastname, email, password):
    self.c1_name = c1_name.title()

class Category2(db.Model):
  __tablename__ = 'c2'
  c2_name = db.Column(db.String(45), primary_key = True, nullable=False)

  def __init__(self, firstname, lastname, email, password):
    self.c2_name = c1_name.title()

class Emots(db.Model):
  __tablename__ = 'emots'
  emot_name = db.Column(db.String(45), primary_key = True, nullable=False)
  c1_name = db.relationship('c1_name', backref=db.backref('c1'))
  c2_name = db.relationship('c2_name', backref=db.backref('c2'))

  def __init__(self, firstname, lastname, email, password):
    self.emot_name = emot_name.title()
