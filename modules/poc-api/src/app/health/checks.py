import os
import psycopg2
import boto3
from botocore.exceptions import ClientError

def check_database_connection():
    try:
        conn = psycopg2.connect(
            dbname=os.getenv('DB_NAME'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            host=os.getenv('DB_HOST'),
            port=os.getenv('DB_PORT', '5432')
        )
        conn.close()
        return True
    except Exception as e:
        print(f"Database connection failed: {str(e)}")
        return False

def check_s3_connection():
    try:
        s3 = boto3.client('s3',
            aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
            aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
            region_name=os.getenv('AWS_DEFAULT_REGION', 'us-east-1')
        )

        # Try to list objects (with max 1 item) to verify permissions
        s3.list_objects_v2(
            Bucket=os.getenv('S3_BUCKET_NAME'),
            MaxKeys=1
        )
        return True
    except ClientError as e:
        print(f"S3 connection failed: {str(e)}")
        return False 