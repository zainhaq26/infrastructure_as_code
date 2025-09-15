# Free Tier Environment Outputs
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

# EC2 Outputs
output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_free_tier.instance_ids[0]
}

output "ec2_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_free_tier.instance_public_ips[0]
}

output "ec2_instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = module.ec2_free_tier.instance_public_dns[0]
}

# EBS Outputs
output "ebs_volume_id" {
  description = "ID of the EBS volume"
  value       = module.ebs_free_tier.volume_id
}

# ECS Outputs
output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs_free_tier.cluster_arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs_free_tier.cluster_name
}

# CloudWatch Outputs
output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.cloudwatch_free_tier.log_group_name
}
