# Development Environment Outputs
output "aws_account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

# EKS Outputs
output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_dev.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks_dev.cluster_security_group_id
}

# ECS Outputs
output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = module.ecs_dev.cluster_arn
}

# EC2 Outputs
output "ec2_instance_public_ips" {
  description = "List of public IP addresses assigned to the instances"
  value       = module.ec2_dev.instance_public_ips
}
