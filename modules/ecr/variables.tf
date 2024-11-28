variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "image_retention_count" {
  description = "Number of images to keep in ECR"
  type        = number
  default     = 20
}

variable "scan_on_push" {
  description = "Enable scan on push for ECR repository"
  type        = bool
  default     = false
} 