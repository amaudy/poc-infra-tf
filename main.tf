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
}

module "networks" {
  source = "./modules/awsnetworks"

  aws_region   = var.aws_region
  project_name = var.project_name
}
