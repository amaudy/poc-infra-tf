from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routes import upload

app = FastAPI(title="POC API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Restrict this in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(upload.router, prefix="/api", tags=["upload"])

@app.get("/health")
async def health_check():
    return {"status": "healthy"} 