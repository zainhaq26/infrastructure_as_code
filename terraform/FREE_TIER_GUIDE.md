# AWS Free Tier Guide for Terraform Infrastructure

This guide ensures your Terraform infrastructure stays within AWS Free Tier limits to avoid unexpected charges.

## 🆓 AWS Free Tier Limits

### EC2 (Elastic Compute Cloud)
- **750 hours/month** of t2.micro instances (Linux/Windows)
- **30 GB** of EBS General Purpose (gp2) storage
- **2 million I/O operations** with EBS
- **1 GB** of snapshot storage
- **15 GB** of bandwidth out aggregated across all AWS services

### EKS (Elastic Kubernetes Service)
- **No free tier** - EKS charges $0.10/hour for cluster management
- **Node costs** - You pay for EC2 instances used as nodes
- **Recommendation**: Use ECS Fargate instead for free tier

### ECS (Elastic Container Service)
- **Fargate**: No free tier for compute, but you can use minimal resources
- **EC2 Launch Type**: Uses your EC2 free tier allowance
- **Recommendation**: Use minimal Fargate tasks (256 CPU, 512 MB memory)

### Route53
- **Hosted Zone**: $0.50/month per hosted zone (not free)
- **DNS Queries**: First 1 billion queries/month are free
- **Health Checks**: First 50 health checks/month are free

### EBS (Elastic Block Store)
- **30 GB** of General Purpose (gp2) storage
- **2 million I/O operations**
- **1 GB** of snapshot storage

### IAM
- **Free** - No charges for IAM users, roles, or policies

### CloudWatch
- **10 custom metrics**
- **10 alarms**
- **5 GB** of log ingestion
- **1 million API requests**

## ⚠️ Important Free Tier Considerations

### What's NOT Free
- **EKS Cluster Management**: $0.10/hour (~$72/month)
- **Route53 Hosted Zones**: $0.50/month each
- **Elastic IPs**: $0.005/hour when not attached to running instance
- **NAT Gateway**: $0.045/hour + data processing
- **Application Load Balancer**: $0.0225/hour + LCU charges

### What's Free
- **EC2 t2.micro**: 750 hours/month
- **EBS gp2**: 30 GB storage
- **CloudWatch**: Basic monitoring
- **IAM**: All features
- **VPC**: Basic networking

## 🛠️ Free Tier Optimized Configurations

### EC2 Module (Free Tier Compatible)
```hcl
module "ec2_free_tier" {
  source = "../../modules/ec2"
  
  name          = "free-tier-instance"
  instance_type = "t2.micro"        # Free tier eligible
  instance_count = 1                # Limit to 1 instance
  
  # Storage optimization
  root_volume_type = "gp2"          # Free tier eligible
  root_volume_size = 8              # Minimal size (30GB total limit)
  
  # Cost optimization
  create_eip = false                # Avoid EIP charges
  
  tags = {
    FreeTier = "true"
  }
}
```

### ECS Module (Minimal Resources)
```hcl
module "ecs_free_tier" {
  source = "../../modules/ecs"
  
  cluster_name = "free-tier-ecs"
  
  # Minimal Fargate resources
  cpu           = "256"             # Minimum for Fargate
  memory        = "512"             # Minimum for Fargate
  desired_count = 1                 # Single task
  
  tags = {
    FreeTier = "true"
  }
}
```

### EBS Module (Free Tier Limits)
```hcl
module "ebs_free_tier" {
  source = "../../modules/ebs"
  
  name = "free-tier-volume"
  size = 20                         # Within 30GB limit
  type = "gp2"                      # Free tier eligible
  
  tags = {
    FreeTier = "true"
  }
}
```

## 📊 Free Tier Monitoring

### CloudWatch Alarms for Free Tier
```hcl
module "cloudwatch_free_tier" {
  source = "../../modules/cloudwatch"
  
  metric_alarms = {
    "ec2-hours-alert" = {
      alarm_name          = "ec2-free-tier-hours"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "1"
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = "86400"  # 24 hours
      statistic           = "Average"
      threshold           = "80"
      alarm_description   = "EC2 usage approaching free tier limit"
    }
  }
}
```

## 💰 Cost Optimization Tips

### 1. Use t2.micro Instances
- Only instance type eligible for free tier
- 1 vCPU, 1 GB RAM
- Sufficient for development and testing

### 2. Minimize Storage
- Use 8GB root volumes
- Total EBS limit: 30GB
- Delete unused snapshots

### 3. Avoid These Services
- **EKS**: Use ECS Fargate instead
- **Elastic IPs**: Use dynamic public IPs
- **NAT Gateway**: Use NAT instances or public subnets
- **Application Load Balancer**: Use simple EC2 instances

### 4. Monitor Usage
- Set up billing alerts
- Use AWS Cost Explorer
- Review monthly usage reports

### 5. Clean Up Resources
- Stop instances when not in use
- Delete unused volumes and snapshots
- Remove unused security groups and key pairs

## 🚨 Free Tier Alerts Setup

### Billing Alert
```hcl
resource "aws_budgets_budget" "free_tier" {
  name         = "free-tier-budget"
  budget_type  = "COST"
  limit_amount = "5.00"  # Alert at $5
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filters = {
    Tag = [
      "FreeTier:true"
    ]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_email_addresses = ["your-email@example.com"]
  }
}
```

## 📋 Free Tier Checklist

### Before Deploying
- [ ] Use t2.micro instances only
- [ ] Limit EBS storage to 30GB total
- [ ] Avoid EKS (use ECS instead)
- [ ] Don't create Elastic IPs
- [ ] Use minimal CloudWatch resources

### After Deploying
- [ ] Set up billing alerts
- [ ] Monitor usage in AWS Console
- [ ] Stop instances when not needed
- [ ] Clean up unused resources regularly

### Monthly Review
- [ ] Check AWS Free Tier usage
- [ ] Review billing dashboard
- [ ] Delete unused resources
- [ ] Update resource tags

## 🔧 Environment-Specific Configurations

### Development Environment (Free Tier)
```hcl
# environments/dev/main.tf
module "ec2_dev" {
  source = "../../modules/ec2"
  
  name          = "dev-instance"
  instance_type = "t2.micro"
  instance_count = 1
  
  tags = {
    Environment = "dev"
    FreeTier    = "true"
  }
}
```

### Production Environment (Paid)
```hcl
# environments/prod/main.tf
module "ec2_prod" {
  source = "../../modules/ec2"
  
  name          = "prod-instance"
  instance_type = "t3.small"  # Paid tier
  instance_count = 2
  
  tags = {
    Environment = "prod"
    FreeTier    = "false"
  }
}
```

## 📚 Additional Resources

- [AWS Free Tier Details](https://aws.amazon.com/free/)
- [AWS Free Tier Calculator](https://calculator.aws/)
- [AWS Billing Dashboard](https://console.aws.amazon.com/billing/)
- [AWS Cost Explorer](https://console.aws.amazon.com/cost-management/home)

## ⚠️ Disclaimer

Free tier limits and availability may change. Always check the latest AWS Free Tier terms and conditions. This guide is for educational purposes and should not be considered as official AWS documentation.
