aws_region         = "us-east-1"
project_name       = "poc-devops"
instance_type      = "t3.large"
environment        = "dev"
log_retention_days = 3
api_image          = "058264373862.dkr.ecr.us-east-1.amazonaws.com/poc-devops-dev:a4151bb5"
api_cpu            = 256
api_memory         = 512
api_desired_count  = 2

# Database configuration
database_name     = "pocdb"
database_username = "pocadmin"
database_password_secret_arn = "arn:aws:secretsmanager:us-east-1:058264373862:secret:poc-devops/dev/db-password"
rds_instance_class = "db.t3.micro"
rds_backup_retention_days = 7
rds_multi_az = false  # Single AZ for dev
database_password_secret_name = "poc-devops/dev/db-password"