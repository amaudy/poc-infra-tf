from fastapi import APIRouter, HTTPException
from . import checks

router = APIRouter()

@router.get("/health")
async def health_check():
    health_status = {
        "status": "healthy",
        "database": checks.check_database_connection(),
        "s3": checks.check_s3_connection()
    }
    
    # If any check fails, return 500
    if not all(health_status.values()):
        raise HTTPException(status_code=500, detail=health_status)
    
    return health_status 