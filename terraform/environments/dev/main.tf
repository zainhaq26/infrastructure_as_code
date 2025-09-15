# Development Environment Configuration
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
      Environment = "dev"
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module (you would need to create this or use an existing one)
# module "vpc" {
#   source = "../../modules/vpc"
#   
#   name               = "${var.project_name}-dev-vpc"
#   cidr               = "10.0.0.0/16"
#   availability_zones = data.aws_availability_zones.available.names
#   
#   tags = {
#     Environment = "dev"
#   }
# }

# Example EKS Cluster for Development (Free Tier Compatible)
module "eks_dev" {
  source = "../../modules/eks"

  cluster_name = "${var.project_name}-dev-eks"
  subnet_ids   = var.subnet_ids # You would get these from your VPC module

  # Free tier settings - minimal resources
  desired_size = 1
  max_size     = 1  # Free tier: limit to 1 node
  min_size     = 1

  instance_types = ["t3.micro"]  # Free tier compatible

  tags = {
    Environment = "dev"
    Purpose     = "development"
    FreeTier    = "true"
  }
}

# Example ECS Cluster for Development (Free Tier Compatible)
module "ecs_dev" {
  source = "../../modules/ecs"

  cluster_name = "${var.project_name}-dev-ecs"

  # Free tier settings - minimal resources
  desired_count = 1
  cpu          = "256"   # Free tier: minimum for Fargate
  memory       = "512"   # Free tier: minimum for Fargate

  tags = {
    Environment = "dev"
    Purpose     = "development"
    FreeTier    = "true"
  }
}

# Example EC2 Instance for Development (Free Tier Compatible)
module "ec2_dev" {
  source = "../../modules/ec2"

  name         = "${var.project_name}-dev-instance"
  instance_type = "t2.micro"  # Free tier: t2.micro is free for 12 months
  subnet_id    = var.subnet_ids[0] # You would get this from your VPC module

  # Free tier settings
  create_eip = false  # Free tier: EIP charges apply when not attached to running instance
  root_volume_size = 8  # Free tier: minimal root volume size

  tags = {
    Environment = "dev"
    Purpose     = "development"
    FreeTier    = "true"
  }
}
