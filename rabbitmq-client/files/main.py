from fastapi import FastAPI
import pika

app = FastAPI()

@app.get("/")
def read_root():
    return "fastapi01"