output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.filesrepo.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.filesrepo.arn
}

output "kms_key_id" {
  description = "The ID of the KMS key"
  value       = aws_kms_key.filesrepo.id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.filesrepo.arn
} 