# EKS Cluster Outputs
output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = aws_iam_role.eks_cluster.name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = aws_iam_role.eks_cluster.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_platform_version" {
  description = "Platform version for the EKS cluster"
  value       = aws_eks_cluster.main.platform_version
}

output "cluster_status" {
  description = "Status of the EKS cluster"
  value       = aws_eks_cluster.main.status
}

# EKS Node Group Outputs
output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = var.create_node_group ? aws_eks_node_group.main[0].arn : null
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = var.create_node_group ? aws_eks_node_group.main[0].status : null
}

output "node_group_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  value       = var.create_node_group ? aws_eks_node_group.main[0].capacity_type : null
}

output "node_group_instance_types" {
  description = "Set of instance types associated with the EKS Node Group"
  value       = var.create_node_group ? aws_eks_node_group.main[0].instance_types : null
}

output "node_group_scaling_config" {
  description = "Configuration block with scaling settings"
  value       = var.create_node_group ? aws_eks_node_group.main[0].scaling_config : null
}
