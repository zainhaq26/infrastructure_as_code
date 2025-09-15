# Free Tier Optimized Configuration
# This configuration uses only AWS Free Tier eligible resources

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
data "aws_availability_zones" "available" {
  state = "available"
}

# Free Tier EC2 Instance
module "ec2_free_tier" {
  source = "../../modules/ec2"

  name          = "${var.project_name}-free-tier"
  instance_type = "t2.micro"  # Free tier eligible
  instance_count = 1          # Limit to 1 instance
  
  # Free tier storage optimization
  root_volume_type = "gp2"    # Free tier eligible
  root_volume_size = 8        # Minimal size (30GB total limit)
  
  # Cost optimization
  create_eip = false          # Avoid EIP charges
  
  # Basic security group (SSH only)
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    }
  ]

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
  }
}

# Free Tier EBS Volume (if needed)
module "ebs_free_tier" {
  source = "../../modules/ebs"

  name = "${var.project_name}-free-tier-volume"
  size = 20                    # Within 30GB limit
  type = "gp2"                 # Free tier eligible
  
  # Don't attach to instance by default to avoid costs
  attach_to_instance = false

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
  }
}

# Free Tier ECS Cluster (minimal resources)
module "ecs_free_tier" {
  source = "../../modules/ecs"

  cluster_name = "${var.project_name}-free-tier-ecs"
  
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

# Free Tier CloudWatch Log Group
module "cloudwatch_free_tier" {
  source = "../../modules/cloudwatch"

  log_group_name = "/aws/free-tier/${var.project_name}"
  log_retention_in_days = 1    # Minimal retention

  # Basic monitoring alarms
  metric_alarms = {
    "ec2-cpu-high" = {
      alarm_name          = "free-tier-ec2-cpu-high"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = "300"
      statistic           = "Average"
      threshold           = "80"
      alarm_description   = "EC2 CPU usage is high"
      alarm_actions       = []
    }
  }

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
  }
}
