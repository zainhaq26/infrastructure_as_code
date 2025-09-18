# EC2 Instance Configuration for Free Tier
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

# Security Group for EC2
resource "aws_security_group" "free_tier" {
  name_prefix = "${var.project_name}-free-tier-sg-"
  description = "Security group for free tier EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
    Name        = "${var.project_name}-free-tier-security-group"
  }
}

# SSH Key Pair
resource "aws_key_pair" "default" {
  key_name   = "my-key-pair"
  public_key = var.ssh_public_key
}

# EC2 Instance
resource "aws_instance" "free_tier" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2 AMI (us-east-1)
  instance_type = "t3.micro"  # Free tier eligible
  key_name      = aws_key_pair.default.key_name

  vpc_security_group_ids = [aws_security_group.free_tier.id]

  root_block_device {
    volume_type = "gp2"  # Free tier eligible
    volume_size = 8      # Minimal size (30GB total limit)
    encrypted   = false
  }

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
    Name        = "${var.project_name}-free-tier-instance"
  }
}

# EBS Volume
resource "aws_ebs_volume" "free_tier" {
  availability_zone = aws_instance.free_tier.availability_zone
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
    Name        = "${var.project_name}-free-tier-volume"
  }
}

# CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
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

  dimensions = {
    InstanceId = aws_instance.free_tier.id
  }

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
    Name        = "free-tier-ec2-cpu-high"
  }
}
