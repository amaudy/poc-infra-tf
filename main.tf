terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

module "networks" {
  source = "./modules/awsnetworks"

  aws_region   = var.aws_region
  project_name = var.project_name
}

module "ecs" {
  source = "./modules/ecs"

  project_name       = var.project_name
  environment        = var.environment
  log_retention_days = var.log_retention_days
}

module "ecr" {
  source = "./modules/ecr"

  project_name         = var.project_name
  environment         = var.environment
  image_retention_count = 20  # Keep last 20 images
  scan_on_push        = false
}

module "poc_api" {
  source = "./modules/poc-api"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id           = module.networks.vpc_id
  private_subnet_ids = module.networks.private_subnet_ids
  public_subnet_ids = module.networks.public_subnet_ids
  ecs_cluster_id   = module.ecs.cluster_id
  container_image  = var.api_image
  cpu             = var.api_cpu
  memory          = var.api_memory
  desired_count   = var.api_desired_count
}

module "filesrepo" {
  source = "./modules/filesrepo"

  project_name = var.project_name
  environment  = var.environment
}
