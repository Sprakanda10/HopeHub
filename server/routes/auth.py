
import uuid
import bcrypt
from fastapi import Depends, HTTPException
from fastapi import APIRouter
from models.user import User
from pydantic_schemas.user_create import UserCreate
from sqlalchemy.orm import Session
from database import get_db
from server.pydantic_schemas.user_login import UserLogin

router= APIRouter()

@router.post('/signup',status_code=201)
def signup_user(user:UserCreate, db: Session = Depends(get_db)):
  user_db= db.query(User).filter(User.email==user.email).first()
  if user_db:
    raise HTTPException(status_code=400, detail="User already exists")
  
  hashed_pw= bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
  user_db=User( id= str(uuid.uuid4()),name=user.name,email=user.email,password=hashed_pw)
  db.add(user_db)
  db.commit()
  db.refresh(user_db)
  return user_db

@router.post('/login')
def login_user(user:UserLogin, db: Session = Depends(get_db)):
  user_db= db.query(User).filter(User.email==user.email).first()
  if not user_db:
    raise HTTPException(status_code=400, detail="User does not exist")
  
  if not bcrypt.checkpw(user.password.encode(), user_db.password):
    raise HTTPException(status_code=400, detail="Invalid password")
  
  return user_db