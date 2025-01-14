output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networks.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.networks.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.networks.private_subnet_ids
}

output "nat_gateway_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = module.networks.nat_gateway_ip
}

output "public_subnet_names" {
  description = "Names of the public subnets"
  value       = module.networks.public_subnet_names
}

output "private_subnet_names" {
  description = "Names of the private subnets"
  value       = module.networks.private_subnet_names
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = module.ecr.repository_name
}

output "api_url" {
  description = "The URL of the POC API"
  value       = module.poc_api.api_url
}

output "filesrepo_bucket_id" {
  description = "The name of the filesrepo bucket"
  value       = module.filesrepo.bucket_id
}

output "filesrepo_bucket_arn" {
  description = "The ARN of the filesrepo bucket"
  value       = module.filesrepo.bucket_arn
}

output "filesrepo_kms_key_arn" {
  description = "The ARN of the filesrepo KMS key"
  value       = module.filesrepo.kms_key_arn
} 