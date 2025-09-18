# ECS Cluster Configuration for Free Tier
# Deploy with: terraform apply

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "free-tier"
      Project     = var.project_name
      ManagedBy   = "Terraform"
      FreeTier    = "true"
    }
  }
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ECS Cluster
module "ecs_free_tier" {
  source = "../../../modules/ecs"

  cluster_name = "${var.project_name}-free-tier-ecs"
  
  # Task definition
  task_definition_family = "${var.project_name}-free-tier-task"
  
  # Minimal Fargate resources
  cpu           = "256"        # Minimum for Fargate
  memory        = "512"        # Minimum for Fargate
  desired_count = 1            # Single task
  
  # Minimal logging
  log_retention_in_days = 1    # Minimal retention

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
  }
}
