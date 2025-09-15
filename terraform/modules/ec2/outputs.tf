# EC2 Instance Outputs
output "instance_ids" {
  description = "List of IDs of instances"
  value       = aws_instance.main[*].id
}

output "instance_arns" {
  description = "List of ARNs of instances"
  value       = aws_instance.main[*].arn
}

output "instance_public_ips" {
  description = "List of public IP addresses assigned to the instances"
  value       = aws_instance.main[*].public_ip
}

output "instance_private_ips" {
  description = "List of private IP addresses assigned to the instances"
  value       = aws_instance.main[*].private_ip
}

output "instance_public_dns" {
  description = "List of public DNS names assigned to the instances"
  value       = aws_instance.main[*].public_dns
}

output "instance_private_dns" {
  description = "List of private DNS names assigned to the instances"
  value       = aws_instance.main[*].private_dns
}

output "instance_availability_zones" {
  description = "List of availability zones of instances"
  value       = aws_instance.main[*].availability_zone
}

output "instance_subnet_ids" {
  description = "List of IDs of VPC subnets of instances"
  value       = aws_instance.main[*].subnet_id
}

output "instance_vpc_security_group_ids" {
  description = "List of associated security groups of instances"
  value       = aws_instance.main[*].vpc_security_group_ids
}

output "instance_key_names" {
  description = "List of key names of instances"
  value       = aws_instance.main[*].key_name
}

output "instance_tenancies" {
  description = "List of tenancies of instances"
  value       = aws_instance.main[*].tenancy
}

output "instance_states" {
  description = "List of states of instances"
  value       = aws_instance.main[*].instance_state
}

# Elastic IP Outputs
output "eip_ids" {
  description = "List of IDs of the Elastic IPs"
  value       = aws_eip.main[*].id
}

output "eip_public_ips" {
  description = "List of public IP addresses of the Elastic IPs"
  value       = aws_eip.main[*].public_ip
}

output "eip_public_dns" {
  description = "List of public DNS names of the Elastic IPs"
  value       = aws_eip.main[*].public_dns
}

# Security Group Outputs
output "security_group_id" {
  description = "ID of the security group"
  value       = length(aws_security_group.main) > 0 ? aws_security_group.main[0].id : null
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = length(aws_security_group.main) > 0 ? aws_security_group.main[0].arn : null
}

output "security_group_name" {
  description = "Name of the security group"
  value       = length(aws_security_group.main) > 0 ? aws_security_group.main[0].name : null
}
