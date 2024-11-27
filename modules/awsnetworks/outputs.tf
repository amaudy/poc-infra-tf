output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "public_subnet_names" {
  description = "Names of the public subnets"
  value       = aws_subnet.public[*].tags.Name
}

output "private_subnet_names" {
  description = "Names of the private subnets"
  value       = aws_subnet.private[*].tags.Name
} 