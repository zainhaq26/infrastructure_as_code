# EKS Cluster Configuration for Free Tier
# Note: EKS is not included in AWS Free Tier, but this configuration uses minimal resources
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

# VPC for EKS
module "vpc_eks" {
  source = "../../../modules/vpc"
  
  vpc_name = "${var.project_name}-eks-vpc"
  vpc_cidr = "10.1.0.0/16"
  
  # Use only 2 AZs to minimize costs
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  
  # Smaller subnets for cost optimization
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.10.0/24", "10.1.20.0/24"]
  
  # Disable NAT Gateway for free tier (will use public subnets for worker nodes)
  enable_nat_gateway = false
  
  tags = {
    Environment = var.environment
    Purpose     = "eks-cluster"
    Project     = var.project_name
    FreeTier    = "true"
  }
}

# EKS Cluster
module "eks_cluster" {
  source = "../../../modules/eks"
  
  cluster_name = "${var.project_name}-eks-cluster"
  kubernetes_version = "1.28"
  
  # Use public subnets for free tier (no NAT Gateway costs)
  subnet_ids = module.vpc_eks.public_subnet_ids
  
  # Security settings
  endpoint_private_access = false
  endpoint_public_access  = true
  public_access_cidrs     = ["0.0.0.0/0"]
  
  # Logging configuration (minimal for cost)
  enabled_cluster_log_types = ["api", "audit"]
  log_retention_in_days     = 1
  
  # Node group configuration (free tier compatible)
  create_node_group = true
  node_group_name   = "main"
  capacity_type     = "ON_DEMAND"
  instance_types    = ["t3.micro"]  # Smallest instance type
  
  # Scaling configuration (minimal for free tier)
  desired_size = 2
  max_size     = 2
  min_size     = 1
  
  max_unavailable_percentage = 25
  
  tags = {
    Environment = var.environment
    Purpose     = "eks-cluster"
    Project     = var.project_name
    FreeTier    = "true"
  }
}
