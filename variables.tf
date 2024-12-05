variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 3 # Default for dev environment
}

variable "api_image" {
  description = "Docker image for the API service"
  type        = string
}

variable "api_cpu" {
  description = "CPU units for the API task (1 vCPU = 1024 units)"
  type        = number
  default     = 256
}

variable "api_memory" {
  description = "Memory for the API task (in MiB)"
  type        = number
  default     = 512
}

variable "api_desired_count" {
  description = "Desired number of API tasks"
  type        = number
  default     = 2
}

# Database variables
variable "database_name" {
  description = "Name of the database"
  type        = string
}

variable "database_username" {
  description = "Database master username"
  type        = string
}

variable "database_password_secret_arn" {
  description = "ARN of the existing secret in AWS Secrets Manager containing the database password"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_backup_retention_days" {
  description = "Number of days to retain RDS backups"
  type        = number
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ RDS deployment"
  type        = bool
} 

variable "database_password_secret_name" {
  description = "Name of the secret in AWS Secrets Manager containing the database password"
  type        = string
}