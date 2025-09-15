# Development Environment Variables
variable "aws_region" {
  description = "AWS region for development environment"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "my-project"
}

variable "subnet_ids" {
  description = "List of subnet IDs (you would get these from your VPC module)"
  type        = list(string)
  default     = [] # Replace with actual subnet IDs
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
