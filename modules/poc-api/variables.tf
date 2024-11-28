variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for Fargate tasks"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "container_image" {
  description = "Docker image for the API service"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 8000
}

variable "cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for the task (in MiB)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 2
} 