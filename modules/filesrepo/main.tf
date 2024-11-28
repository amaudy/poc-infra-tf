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