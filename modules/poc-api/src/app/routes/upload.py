from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, validator
import boto3
from botocore.exceptions import ClientError
import os

router = APIRouter()

# Initialize S3 client
s3_client = boto3.client(
    's3',
    region_name=os.getenv('AWS_DEFAULT_REGION')
)

class PresignedUrlRequest(BaseModel):
    file_name: str
    file_type: str
    file_size: int

    @validator('file_size')
    def validate_file_size(cls, v):
        max_size = 10 * 1024 * 1024  # 10MB limit
        if v > max_size:
            raise ValueError(f'File size exceeds maximum allowed size of {max_size/1024/1024}MB')
        return v

@router.post("/generate-upload-url")
async def generate_upload_url(request: PresignedUrlRequest):
    try:
        bucket_name = os.getenv('S3_BUCKET_NAME')
        if not bucket_name:
            raise HTTPException(status_code=500, detail="S3 bucket name not configured")

        url = s3_client.generate_presigned_url(
            'put_object',
            Params={
                'Bucket': bucket_name,
                'Key': request.file_name,
                'ContentType': request.file_type,
                'ContentLength': request.file_size
            },
            ExpiresIn=3600  # URL expires in 1 hour
        )
        
        return {
            "upload_url": url,
            "expires_in": 3600,
            "max_size": 10 * 1024 * 1024  # 10MB in bytes
        }
    except ClientError as e:
        raise HTTPException(status_code=500, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) 