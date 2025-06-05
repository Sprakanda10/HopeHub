import os
import sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)) + "/..") 
from fastapi import FastAPI
from routes import auth
from models.base import Base
from database import engine
from fastapi.middleware.cors import CORSMiddleware

app= FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # <- allow all during development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(auth.router, prefix='/auth', tags=['auth'])
    
Base.metadata.create_all(engine)
