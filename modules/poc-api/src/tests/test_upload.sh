#!/bin/bash

# Your API endpoint (replace with your ALB DNS)
API_ENDPOINT="http://your-alb-dns/api/generate-upload-url"

# Create test file
echo "Hello, this is a test file" > test.txt
FILE_SIZE=$(stat -f%z test.txt)

# Get presigned URL
echo "Getting presigned URL..."
RESPONSE=$(curl -s -X POST $API_ENDPOINT \
  -H "Content-Type: application/json" \
  -d "{
    \"file_name\": \"test.txt\",
    \"file_type\": \"text/plain\",
    \"file_size\": $FILE_SIZE
  }")

# Extract URL from response
UPLOAD_URL=$(echo $RESPONSE | jq -r '.upload_url')

if [ -z "$UPLOAD_URL" ] || [ "$UPLOAD_URL" == "null" ]; then
    echo "Failed to get presigned URL"
    echo "Response: $RESPONSE"
    rm test.txt
    exit 1
fi

echo "Got presigned URL"

# Upload file
echo "Uploading file..."
UPLOAD_RESPONSE=$(curl -s -X PUT -T test.txt \
  -H "Content-Type: text/plain" \
  "$UPLOAD_URL")

echo "Upload complete"
echo "Response: $UPLOAD_RESPONSE"

# Cleanup
rm test.txt 