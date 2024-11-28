from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="POC API")

class HealthCheck(BaseModel):
    status: str
    environment: str

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/health", response_model=HealthCheck)
def health_check():
    return {
        "status": "healthy",
        "environment": "development"
    } 