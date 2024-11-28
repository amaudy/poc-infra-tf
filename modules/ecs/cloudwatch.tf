locals {
  retention_days = {
    dev     = 3
    staging = 7
    prod    = 7
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = lookup(local.retention_days, var.environment, var.log_retention_days)
} 