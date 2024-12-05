resource "aws_kms_key" "filesrepo" {
  description             = "KMS key for filesrepo S3 bucket encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "${var.project_name}-filesrepo-key"
    Environment = var.environment
  }
}

resource "aws_kms_alias" "filesrepo" {
  name          = "alias/${var.project_name}-filesrepo-key"
  target_key_id = aws_kms_key.filesrepo.key_id
}

resource "aws_s3_bucket" "filesrepo" {
  bucket = "${var.project_name}-${var.environment}-filesrepo"

  tags = {
    Name        = "${var.project_name}-filesrepo"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "filesrepo" {
  bucket = aws_s3_bucket.filesrepo.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "filesrepo" {
  bucket = aws_s3_bucket.filesrepo.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.filesrepo.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "filesrepo" {
  bucket = aws_s3_bucket.filesrepo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_cors_configuration" "filesrepo" {
  bucket = aws_s3_bucket.filesrepo.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET"]
    allowed_origins = ["*"] # Restrict this in production
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "filesrepo" {
  bucket = aws_s3_bucket.filesrepo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPresignedUrls"
        Effect    = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.filesrepo.arn}/*"
        Condition = {
          StringEquals = {
            "aws:PrincipalArn": [aws_iam_role.api_s3_role.arn]
          }
        }
      }
    ]
  })
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Create IAM role for API
resource "aws_iam_role" "api_s3_role" {
  name = "${var.project_name}-${var.environment}-api-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for S3 presigned URLs
resource "aws_iam_role_policy" "api_s3_policy" {
  name = "${var.project_name}-${var.environment}-api-s3-policy"
  role = aws_iam_role.api_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.filesrepo.arn}/*"
      }
    ]
  })
}

# Add output for the role ARN
output "api_s3_role_arn" {
  value = aws_iam_role.api_s3_role.arn
} 