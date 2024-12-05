locals {

  common_tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}"
      Environment = var.environment
      Terraform   = "true"
      Service     = var.project_name
      CreatedBy   = "terraform"
      CreatedAt   = timestamp()
    }
  )
}

data "aws_secretsmanager_secret" "db_password" {
  name = "rds/${var.project_name}/${var.environment}/db-password"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

locals {
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
}

resource "aws_db_subnet_group" "main" {
  name        = "${var.project_name}-${var.environment}"
  subnet_ids  = var.subnet_ids
  description = "Subnet group for ${var.project_name} RDS instance"

  lifecycle {
    ignore_changes = [
      tags["CreatedAt"]
    ]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-subnet-group"
    }
  )
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-${var.environment}-rds-"
  vpc_id      = var.vpc_id
  description = "Security group for ${var.project_name} RDS instance"

  lifecycle {
    ignore_changes = [
      tags["CreatedAt"]
    ]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Consider restricting this in production
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-sg"
      Type = "database"
    }
  )
}

resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-${var.environment}"
  engine            = "postgres"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.database_name
  username = var.database_username
  password = local.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az

  skip_final_snapshot = true # Set to false for production

  storage_encrypted = true

  lifecycle {
    ignore_changes = [
      tags["CreatedAt"]
    ]
  }

  tags = merge(
    local.common_tags,
    {
      Name          = "${var.project_name}-${var.environment}-rds"
      Engine        = "postgresql"
      EngineVersion = var.engine_version
      DatabaseName  = var.database_name
    }
  )
}

