# ECS Variables
variable "aws_region" {
  description = "AWS region for free tier environment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "free-tier-project"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "free-tier"
}
