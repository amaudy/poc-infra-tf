from fastapi import FastAPI
import uvicorn
from pydantic import BaseModel

app = FastAPI()

API_VERSION = "1.0"

class HealthCheck(BaseModel):
    status: str
    version: str

@app.get("/")
async def root():
    return {
        "message": "Hello from POC API",
        "version": API_VERSION
    }

@app.get("/health", response_model=HealthCheck)
async def health():
    return HealthCheck(
        status="healthy",
        version=API_VERSION
    )

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000) 