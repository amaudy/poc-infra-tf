output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.api.name
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.api.dns_name
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.api.arn
}

output "api_url" {
  description = "The URL of the API Load Balancer"
  value       = "http://${aws_lb.api.dns_name}"
}
