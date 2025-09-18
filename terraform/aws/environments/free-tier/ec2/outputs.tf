# EC2 Outputs
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

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.free_tier.id
}

output "ec2_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.free_tier.public_ip
}

output "ec2_instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.free_tier.public_dns
}

output "ebs_volume_id" {
  description = "ID of the EBS volume"
  value       = aws_ebs_volume.free_tier.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.free_tier.id
}

output "key_pair_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.default.key_name
}
