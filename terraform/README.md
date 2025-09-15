# AWS Terraform Infrastructure

This repository contains organized Terraform modules for AWS infrastructure components, designed for scalability and maintainability.

## 📁 Project Structure

```
terraform/
├── modules/                    # Reusable Terraform modules
│   ├── eks/                   # Amazon EKS (Kubernetes)
│   ├── ecs/                   # Amazon ECS (Container Service)
│   ├── ec2/                   # Amazon EC2 (Virtual Machines)
│   ├── route53/               # Amazon Route53 (DNS)
│   ├── ebs/                   # Amazon EBS (Elastic Block Store)
│   ├── iam/                   # Amazon IAM (Identity & Access Management)
│   └── cloudwatch/            # Amazon CloudWatch (Monitoring)
├── environments/              # Environment-specific configurations
│   ├── dev/                   # Development environment
│   ├── staging/               # Staging environment
│   └── prod/                  # Production environment
└── shared/                    # Shared configurations
    ├── providers.tf           # Provider configurations
    ├── variables.tf           # Global variables
    └── outputs.tf             # Global outputs
```

## 🚀 Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured
- AWS credentials with appropriate permissions

### 🆓 Free Tier Compatibility

This infrastructure is optimized for AWS Free Tier usage. See [FREE_TIER_GUIDE.md](./FREE_TIER_GUIDE.md) for detailed information about:
- Free tier limits and restrictions
- Cost optimization strategies
- Monitoring and alerting setup
- Resource cleanup recommendations

### Basic Usage

1. **Navigate to an environment:**
   ```bash
   cd environments/dev
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Plan your infrastructure:**
   ```bash
   terraform plan
   ```

4. **Apply your infrastructure:**
   ```bash
   terraform apply
   ```

## 📦 Available Modules

### EKS (Elastic Kubernetes Service)
- **Purpose**: Managed Kubernetes clusters
- **Features**: 
  - Cluster creation with configurable versions
  - Node groups with auto-scaling
  - IAM roles and policies
  - CloudWatch logging
- **Usage**: Perfect for containerized applications requiring orchestration
- **⚠️ Free Tier Note**: EKS charges $0.10/hour (~$72/month). Consider ECS Fargate for free tier usage.

### ECS (Elastic Container Service)
- **Purpose**: Container orchestration service
- **Features**:
  - Fargate and EC2 launch types
  - Task definitions and services
  - Load balancer integration
  - Service discovery
- **Usage**: Ideal for microservices and containerized applications

### EC2 (Elastic Compute Cloud)
- **Purpose**: Virtual machines
- **Features**:
  - Multiple instance types
  - Security groups
  - Elastic IPs
  - EBS volume management
- **Usage**: Traditional server workloads and applications
- **✅ Free Tier**: t2.micro instances (750 hours/month) and 30GB EBS storage

### Route53 (DNS Service)
- **Purpose**: Domain name system
- **Features**:
  - Hosted zones
  - DNS records (A, CNAME, MX, etc.)
  - Health checks
  - Routing policies
- **Usage**: Domain management and traffic routing

### EBS (Elastic Block Store)
- **Purpose**: Block storage volumes
- **Features**:
  - Volume creation and attachment
  - Snapshots and copies
  - Encryption support
  - Performance optimization
- **Usage**: Persistent storage for EC2 instances

### IAM (Identity & Access Management)
- **Purpose**: Access control and permissions
- **Features**:
  - Users, roles, and groups
  - Policies and permissions
  - Access keys management
  - Cross-account access
- **Usage**: Security and access management

### CloudWatch (Monitoring)
- **Purpose**: Monitoring and observability
- **Features**:
  - Log groups and streams
  - Metric alarms
  - Dashboards
  - Event rules and targets
- **Usage**: Application and infrastructure monitoring

## 🏗️ Environment Management

### Development Environment
- **Purpose**: Development and testing
- **Characteristics**:
  - Smaller instance sizes
  - Single availability zone
  - Minimal redundancy
  - Cost-optimized

### Staging Environment
- **Purpose**: Pre-production testing
- **Characteristics**:
  - Production-like configuration
  - Multiple availability zones
  - Load testing capabilities
  - Monitoring enabled

### Production Environment
- **Purpose**: Live production workloads
- **Characteristics**:
  - High availability
  - Multi-AZ deployment
  - Enhanced monitoring
  - Backup and disaster recovery

## 🔧 Configuration

### Variables
Each module accepts variables for customization. Common variables include:
- `name`: Resource naming
- `tags`: Resource tagging
- `environment`: Environment identification
- `region`: AWS region

### Tags
All resources are automatically tagged with:
- `Environment`: dev/staging/prod
- `Project`: Project name
- `ManagedBy`: Terraform
- `CreatedBy`: Creator identification

## 📋 Best Practices

### 1. State Management
- Use remote state backends (S3 + DynamoDB)
- Enable state locking
- Separate state files per environment

### 2. Security
- Use least privilege IAM policies
- Enable encryption at rest and in transit
- Regular security audits

### 3. Cost Optimization
- Use appropriate instance types
- Implement auto-scaling
- Regular resource cleanup

### 4. Monitoring
- Enable CloudWatch logging
- Set up monitoring and alerting
- Implement health checks

## 🚨 Important Notes

### Prerequisites
- Ensure you have a VPC and subnets before using EKS/ECS modules
- Configure AWS credentials before running Terraform
- Review and adjust resource limits based on your AWS account

### Security Considerations
- Never commit AWS credentials to version control
- Use IAM roles instead of access keys when possible
- Regularly rotate access keys and secrets

### Cost Management
- Monitor your AWS bill regularly
- Use cost allocation tags
- Implement budget alerts

## 🔄 Workflow

1. **Plan**: Review changes with `terraform plan`
2. **Review**: Validate configuration and costs
3. **Apply**: Deploy infrastructure with `terraform apply`
4. **Monitor**: Use CloudWatch for monitoring
5. **Update**: Modify and reapply as needed
6. **Destroy**: Clean up with `terraform destroy` when done

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
