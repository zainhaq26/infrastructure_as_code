# EKS Outputs
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

# EKS Cluster Outputs
output "eks_cluster_id" {
  description = "ID of the EKS cluster"
  value       = module.eks_cluster.cluster_id
}

output "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks_cluster.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_cluster.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks_cluster.cluster_security_group_id
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks_cluster.cluster_certificate_authority_data
}

output "eks_node_group_arn" {
  description = "ARN of the EKS Node Group"
  value       = module.eks_cluster.node_group_arn
}

# VPC Outputs for EKS
output "eks_vpc_id" {
  description = "ID of the VPC used by EKS"
  value       = module.vpc_eks.vpc_id
}

output "eks_public_subnet_ids" {
  description = "List of IDs of public subnets used by EKS"
  value       = module.vpc_eks.public_subnet_ids
}

output "eks_private_subnet_ids" {
  description = "List of IDs of private subnets used by EKS"
  value       = module.vpc_eks.private_subnet_ids
}
