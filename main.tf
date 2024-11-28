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

module "app_server" {
  source = "./modules/app-server"

  project_name       = var.project_name
  vpc_id            = module.networks.vpc_id
  private_subnet_ids = module.networks.private_subnet_ids
  public_subnet_ids  = module.networks.public_subnet_ids
  instance_type     = var.instance_type
}

module "ecs" {
  source = "./modules/ecs"

  project_name       = var.project_name
  environment        = var.environment
  log_retention_days = var.log_retention_days
}
