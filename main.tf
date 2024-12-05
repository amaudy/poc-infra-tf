terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"

  backend "s3" {}
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

  project_name          = var.project_name
  environment           = var.environment
  image_retention_count = 20 # Keep last 20 images
  scan_on_push          = false
}

module "poc_api" {
  source = "./modules/poc-api"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.networks.vpc_id
  private_subnet_ids    = module.networks.private_subnet_ids
  public_subnet_ids     = module.networks.public_subnet_ids
  ecs_cluster_id        = module.ecs.cluster_id
  container_image       = var.api_image
  cpu                   = var.api_cpu
  memory                = var.api_memory
  desired_count         = var.api_desired_count
  filesrepo_bucket_name = module.filesrepo.bucket_name
  filesrepo_bucket_arn  = module.filesrepo.bucket_arn
  db_host               = module.rds.db_instance_endpoint
  database_name         = var.database_name
  database_username     = var.database_username
  database_password_arn  = var.database_password_secret_arn
}

module "filesrepo" {
  source = "./modules/filesrepo"

  project_name = var.project_name
  environment  = var.environment
}


module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networks.vpc_id
  subnet_ids   = module.networks.private_subnet_ids
  database_name = var.database_name
  database_username = var.database_username
  
  instance_class = var.rds_instance_class
  
  multi_az = var.rds_multi_az

  secret_name = var.database_password_secret_name
}
