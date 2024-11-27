output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networks.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.networks.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.networks.private_subnet_ids
}

output "nat_gateway_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = module.networks.nat_gateway_ip
}

output "public_subnet_names" {
  description = "Names of the public subnets"
  value       = module.networks.public_subnet_names
}

output "private_subnet_names" {
  description = "Names of the private subnets"
  value       = module.networks.private_subnet_names
} 