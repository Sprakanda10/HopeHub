
from sqlalchemy import VARCHAR, Column, LargeBinary, Text
from server.models.base import Base


class User(Base):
    __tablename__ = 'users'

    id= Column(Text,primary_key=True, index=True)
    name=Column(VARCHAR(100))
    email=Column(VARCHAR(100))
    password=Column(LargeBinary)
