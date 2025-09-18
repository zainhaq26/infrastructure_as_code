# Free Tier Infrastructure - Modular Structure

This directory contains a modular Terraform structure for deploying AWS free tier resources. Each service has its own folder with isolated state files.

## 📁 Directory Structure

```
free-tier/
├── README.md                 # This file
├── ec2/                      # EC2 instances and related resources
│   ├── main.tf              # EC2 configuration
│   ├── variables.tf         # EC2 variables
│   ├── outputs.tf           # EC2 outputs
│   └── terraform.tfvars     # EC2 variable values
├── ecs/                      # ECS cluster and services
│   ├── main.tf              # ECS configuration
│   ├── variables.tf         # ECS variables
│   ├── outputs.tf           # ECS outputs
│   └── terraform.tfvars     # ECS variable values
├── eks/                      # EKS cluster and node groups
│   ├── main.tf              # EKS configuration
│   ├── variables.tf         # EKS variables
│   ├── outputs.tf           # EKS outputs
│   └── terraform.tfvars     # EKS variable values
└── shared/                   # Shared resources
    ├── main.tf              # Shared configuration
    ├── variables.tf         # Shared variables
    ├── outputs.tf           # Shared outputs
    └── terraform.tfvars     # Shared variable values
```

## 🚀 Deployment Instructions

### Prerequisites
- AWS CLI configured
- Terraform installed (>= 1.0)
- kubectl installed (for EKS)

### Deploy Individual Services

#### 1. Deploy EC2 (Free Tier Eligible)
```bash
cd ec2/
terraform init
terraform plan
terraform apply
```

#### 2. Deploy ECS (Free Tier Eligible)
```bash
cd ecs/
terraform init
terraform plan
terraform apply
```

#### 3. Deploy EKS (NOT Free Tier - Costs ~$80/month)
```bash
cd eks/
terraform init
terraform plan
terraform apply
```

#### 4. Deploy Shared Resources
```bash
cd shared/
terraform init
terraform plan
terraform apply
```

### Deploy All Services
```bash
# Deploy in order (shared first, then services)
cd shared/ && terraform apply
cd ../ec2/ && terraform apply
cd ../ecs/ && terraform apply
cd ../eks/ && terraform apply  # Optional - costs money
```

## 💰 Cost Information

### Free Tier Eligible:
- **EC2**: t3.micro instance (750 hours/month free for 12 months)
- **ECS**: Fargate tasks (limited free usage)
- **EBS**: 30GB storage (free for 12 months)

### NOT Free Tier:
- **EKS**: ~$0.10/hour (~$73/month) for control plane
- **EC2 instances for EKS**: Additional costs for worker nodes

## 🔧 Configuration

### Variables
Each service has its own `terraform.tfvars` file. Update these files to customize your deployment:

- `aws_region`: AWS region (default: us-east-1)
- `project_name`: Project name (default: free-tier-project)
- `environment`: Environment name (default: free-tier)

### SSH Key for EC2
Add your SSH public key to `ec2/terraform.tfvars`:
```hcl
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC..."
```

## 📊 Outputs

Each service provides its own outputs. Check the `outputs.tf` file in each directory for available outputs.

### Common Outputs:
- `aws_account_id`: Your AWS account ID
- `aws_region`: AWS region
- `environment`: Environment name

### Service-Specific Outputs:
- **EC2**: Instance ID, public IP, security group ID
- **ECS**: Cluster ARN, cluster name
- **EKS**: Cluster endpoint, certificate data, VPC information

## 🧹 Cleanup

### Destroy Individual Services
```bash
cd ec2/
terraform destroy

cd ../ecs/
terraform destroy

cd ../eks/
terraform destroy  # Remember: EKS costs money!
```

### Destroy All Services
```bash
# Destroy in reverse order
cd eks/ && terraform destroy
cd ../ecs/ && terraform destroy
cd ../ec2/ && terraform destroy
cd ../shared/ && terraform destroy
```

## 🔄 State Management

Each service has its own state file:
- `ec2/terraform.tfstate`
- `ecs/terraform.tfstate`
- `eks/terraform.tfstate`
- `shared/terraform.tfstate`

This isolation prevents:
- Stale outputs between services
- Accidental resource conflicts
- Complex dependency management

## 🆘 Troubleshooting

### Common Issues:

1. **SSH Key Missing**: Add your SSH public key to `ec2/terraform.tfvars`
2. **EKS Costs**: Remember EKS is not free - costs ~$80/month
3. **State Conflicts**: Each service has isolated state - no conflicts between services
4. **Module Paths**: Module paths are relative to each service directory

### Getting Help:
- Check the individual service README files
- Review Terraform plan output before applying
- Use `terraform state list` to see managed resources

## 📝 Notes

- This structure solves the stale state problem by isolating each service
- Each service can be deployed independently
- No more mixed outputs or state conflicts
- Easy to add new services by creating new directories
- Perfect for learning and experimentation with AWS free tier
