# Free Tier Deployment Guide

This directory contains separate Terraform files for each AWS component, allowing you to deploy them individually.

## 📁 File Structure

```
free-tier/
├── base.tf              # Common configuration (provider, data sources)
├── ec2.tf               # EC2 instance configuration
├── ebs.tf               # EBS volume configuration
├── ecs.tf               # ECS cluster configuration
├── cloudwatch.tf        # CloudWatch logs and alarms
├── main.tf              # All components (commented out)
├── variables.tf         # Variable definitions
├── outputs.tf           # Output definitions
└── DEPLOYMENT_GUIDE.md  # This file
```

## 🚀 Deployment Options

### Option 1: Deploy Individual Components

#### Deploy Only EC2 Instance:
```bash
terraform init
terraform plan -target=aws_instance.free_tier
terraform apply -target=aws_instance.free_tier
```

#### Deploy Only EBS Volume:
```bash
terraform init
terraform plan -target=aws_ebs_volume.free_tier
terraform apply -target=aws_ebs_volume.free_tier
```

#### Deploy Only ECS Cluster:
```bash
terraform init
terraform plan -target=module.ecs_free_tier
terraform apply -target=module.ecs_free_tier
```

#### Deploy Only CloudWatch:
```bash
terraform init
terraform plan -target=aws_cloudwatch_log_group.free_tier
terraform apply -target=aws_cloudwatch_log_group.free_tier
```

### Option 2: Deploy Multiple Components

#### Deploy EC2 + EBS:
```bash
terraform apply -target=module.ec2_free_tier -target=module.ebs_free_tier
```

#### Deploy EC2 + CloudWatch:
```bash
terraform apply -target=module.ec2_free_tier -target=module.cloudwatch_free_tier
```

### Option 3: Deploy All Components

#### Method 1: Use main.tf (uncomment desired components)
1. Edit `main.tf`
2. Uncomment the components you want
3. Run:
```bash
terraform init
terraform plan
terraform apply
```

#### Method 2: Deploy all separate files
```bash
terraform init
terraform plan
terraform apply
```

## 🎯 Common Use Cases

### 1. Just Want an EC2 Instance:
```bash
terraform apply -target=module.ec2_free_tier
```

### 2. EC2 with Monitoring:
```bash
terraform apply -target=module.ec2_free_tier -target=module.cloudwatch_free_tier
```

### 3. EC2 with Extra Storage:
```bash
terraform apply -target=module.ec2_free_tier -target=module.ebs_free_tier
```

### 4. Full Stack (EC2 + EBS + ECS + CloudWatch):
```bash
terraform apply
```

## 🔧 Useful Commands

### Check What Will Be Deployed:
```bash
terraform plan
```

### Check Specific Component:
```bash
terraform plan -target=module.ec2_free_tier
```

### Destroy Specific Component:
```bash
terraform destroy -target=module.ec2_free_tier
```

### View Outputs:
```bash
terraform output
```

### View State:
```bash
terraform show
```

## 💰 Cost Considerations

- **EC2**: t2.micro is free for 12 months (750 hours/month)
- **EBS**: 30GB free (gp2 storage)
- **ECS**: Fargate has free tier limits
- **CloudWatch**: 5GB logs free, 10 alarms free

## 🚨 Important Notes

1. **Always run `terraform init` first**
2. **Use `-target` for specific deployments**
3. **Check costs before deploying**
4. **Monitor your AWS billing dashboard**
5. **Destroy resources when not needed**

## 📋 Prerequisites

1. AWS credentials configured
2. Terraform installed
3. Appropriate AWS permissions
4. SSH key pair (automatically created from your local key)

## 🔑 SSH Key Setup

The configuration automatically uses your local SSH public key. Make sure you have an SSH key pair:

```bash
# Check if you have an SSH key
ls ~/.ssh/id_rsa.pub

# If you don't have one, create it
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
```

The SSH public key is automatically loaded from `~/.ssh/id_rsa.pub` and used to create the AWS key pair.

## 🔍 Troubleshooting

### If you get module errors:
```bash
terraform init -upgrade
```

### If you get permission errors:
Check your AWS credentials and IAM permissions

### If you get resource conflicts:
```bash
terraform refresh
terraform plan
```
