# Poc Filesharing

- AWS VPC with public and private subnets, and a NAT gateway for private subnets.
- S3 encryption with KMS key.
- ECS (Fargate)
- FastAPI workload deployed in ECS.
- Load balancer in front of the ECS service.
- Cloudwatch logs and metrics.
