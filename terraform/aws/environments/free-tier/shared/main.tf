# Shared Resources for Free Tier Environment
# This folder contains resources that might be shared across multiple services
# Currently empty - add shared resources here as needed

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

# Add shared resources here as needed
# Examples:
# - S3 buckets
# - IAM roles
# - VPC (if shared across services)
# - Route53 zones
