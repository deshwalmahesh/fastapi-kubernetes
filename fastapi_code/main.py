from fastapi import FastAPI
from pymongo import MongoClient
from pydantic import BaseModel
import os

app = FastAPI()

try:
    client = MongoClient(f"mongodb://{os.getenv('MONGODB_USERNAME')}:{os.getenv('MONGODB_PASSWORD')}@{os.getenv('MONGODB_URL')}")
    print("DB Connection successful")
except Exception as e: print(e)


class User(BaseModel): # Define a Pydantic model for the User data
    Name: str
    Age: int
    Occupation: str
    Learning: str

# If the database and collection do not exist, MongoDB will create them automatically
db = client.my_db
collection = db.my_collection


@app.get("/")
def read_root():
    return "Hello from the other sideeeeeee!!!!!!!!"


@app.post("/create_user/")
async def create_user(user: User):
    user_data = user.dict()
    result = collection.insert_one(user_data)
    return {"message": "User added", "id": str(result.inserted_id)}


@app.get("/get_users/{name}")
async def get_user(name: str):
    user = collection.find_one({"Name": name})
    if user is None:
        return {"error": "User not found. Use /create_user/ API to create one"}
    user["_id"] = str(user["_id"])
    return user

@app.get("/health")
def health_check():
    return {"status": "OK"}

