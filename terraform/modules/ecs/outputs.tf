# ECS Cluster Outputs
output "cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_ecs_cluster.main.arn
}

output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

# ECS Task Definition Outputs
output "task_definition_arn" {
  description = "Full ARN of the task definition"
  value       = var.create_task_definition ? aws_ecs_task_definition.main[0].arn : var.task_definition_arn
}

output "task_definition_family" {
  description = "The family of the task definition"
  value       = var.create_task_definition ? aws_ecs_task_definition.main[0].family : null
}

output "task_definition_revision" {
  description = "The revision of the task in a particular family"
  value       = var.create_task_definition ? aws_ecs_task_definition.main[0].revision : null
}

# ECS Service Outputs
output "service_id" {
  description = "The ID of the ECS service"
  value       = var.create_service ? aws_ecs_service.main[0].id : null
}

output "service_name" {
  description = "The name of the ECS service"
  value       = var.create_service ? aws_ecs_service.main[0].name : null
}

output "service_arn" {
  description = "The ARN of the ECS service"
  value       = var.create_service ? aws_ecs_service.main[0].id : null
}

output "service_desired_count" {
  description = "The number of instances of the task definition"
  value       = var.create_service ? aws_ecs_service.main[0].desired_count : null
}

output "service_launch_type" {
  description = "The launch type on which to run your service"
  value       = var.create_service ? aws_ecs_service.main[0].launch_type : null
}

# IAM Role Outputs
output "execution_role_arn" {
  description = "The ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "execution_role_name" {
  description = "The name of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.name
}

output "task_role_arn" {
  description = "The ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "task_role_name" {
  description = "The name of the ECS task role"
  value       = aws_iam_role.ecs_task_role.name
}

output "service_role_arn" {
  description = "The ARN of the ECS service role"
  value       = aws_iam_role.ecs_service_role.arn
}

output "service_role_name" {
  description = "The name of the ECS service role"
  value       = aws_iam_role.ecs_service_role.name
}

# CloudWatch Log Group Output
output "log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_cluster.name
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_cluster.arn
}
