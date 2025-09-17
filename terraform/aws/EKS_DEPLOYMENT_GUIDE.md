# EKS Deployment Guide

This guide explains how to deploy an Amazon EKS (Elastic Kubernetes Service) cluster using the Terraform modules in this repository.

## ⚠️ Important Cost Warning

**EKS is NOT included in the AWS Free Tier.** Deploying EKS will incur costs:
- EKS Control Plane: ~$0.10 per hour (~$73/month)
- EC2 instances for worker nodes: varies by instance type
- Load balancers, NAT gateways, and other resources

## Prerequisites

1. **AWS CLI configured** with appropriate permissions
2. **Terraform installed** (version 1.0+)
3. **kubectl installed** for cluster management
4. **AWS IAM permissions** for EKS, EC2, VPC, and IAM operations

## Quick Start

### Option 1: Deploy EKS with the Free-Tier Environment

1. **Navigate to the free-tier environment:**
   ```bash
   cd environments/free-tier
   ```

2. **Enable EKS deployment** by uncommenting the EKS module in `main.tf`:
   ```hcl
   # Uncomment the EKS module section in main.tf
   module "eks_free_tier" {
     source = "../../modules/eks"
     # ... configuration
   }
   ```

3. **Initialize and deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### Option 2: Deploy EKS Standalone

1. **Use the dedicated EKS configuration:**
   ```bash
   cd environments/free-tier
   ```

2. **Deploy EKS with VPC:**
   ```bash
   terraform apply -target=module.vpc_eks
   terraform apply -target=module.eks_cluster
   ```

## Configuration Options

### EKS Module Variables

| Variable | Description | Default | Free Tier Compatible |
|----------|-------------|---------|---------------------|
| `cluster_name` | Name of the EKS cluster | Required | ✅ |
| `kubernetes_version` | Kubernetes version | "1.28" | ✅ |
| `subnet_ids` | List of subnet IDs | Required | ✅ |
| `endpoint_private_access` | Enable private API endpoint | true | ❌ (costs more) |
| `endpoint_public_access` | Enable public API endpoint | true | ✅ |
| `instance_types` | Worker node instance types | ["t3.micro"] | ✅ |
| `desired_size` | Desired number of nodes | 1 | ✅ |
| `max_size` | Maximum number of nodes | 1 | ✅ |
| `min_size` | Minimum number of nodes | 1 | ✅ |

### VPC Module Variables

| Variable | Description | Default | Free Tier Compatible |
|----------|-------------|---------|---------------------|
| `vpc_cidr` | VPC CIDR block | "10.1.0.0/16" | ✅ |
| `availability_zones` | List of AZs | ["us-east-1a", "us-east-1b"] | ✅ |
| `enable_nat_gateway` | Enable NAT Gateway | false | ✅ (disabled for cost) |
| `public_subnet_cidrs` | Public subnet CIDRs | ["10.1.1.0/24", "10.1.2.0/24"] | ✅ |
| `private_subnet_cidrs` | Private subnet CIDRs | ["10.1.10.0/24", "10.1.20.0/24"] | ✅ |

## Post-Deployment Setup

### 1. Configure kubectl

After deployment, configure kubectl to connect to your cluster:

```bash
# Get the cluster endpoint and certificate
aws eks update-kubeconfig --region us-east-1 --name your-cluster-name

# Verify connection
kubectl get nodes
```

### 2. Install AWS Load Balancer Controller (Optional)

For production workloads, install the AWS Load Balancer Controller:

```bash
# Create IAM policy
curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json

# Create IAM policy
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

# Create service account
kubectl apply -f https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.4/v2_4_4_full.yaml
```

### 3. Deploy a Sample Application

```bash
# Create a simple nginx deployment
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Check the service
kubectl get services
```

## Cost Optimization Tips

1. **Use t3.micro instances** for worker nodes
2. **Disable NAT Gateway** (use public subnets)
3. **Minimize log retention** (1 day)
4. **Use single availability zone** if possible
5. **Delete cluster when not in use**

## Monitoring and Logging

The EKS cluster is configured with:
- CloudWatch logging for API and audit events
- 1-day log retention (minimal cost)
- Basic monitoring through CloudWatch

## Troubleshooting

### Common Issues

1. **Insufficient permissions:**
   ```bash
   # Ensure your AWS credentials have EKS permissions
   aws sts get-caller-identity
   ```

2. **kubectl connection issues:**
   ```bash
   # Update kubeconfig
   aws eks update-kubeconfig --region us-east-1 --name your-cluster-name
   ```

3. **Node group not joining:**
   - Check IAM roles and policies
   - Verify subnet configuration
   - Check security group rules

### Useful Commands

```bash
# Check cluster status
aws eks describe-cluster --name your-cluster-name --region us-east-1

# Check node group status
aws eks describe-nodegroup --cluster-name your-cluster-name --nodegroup-name main --region us-east-1

# View cluster logs
aws logs describe-log-groups --log-group-name-prefix /aws/eks/your-cluster-name
```

## Cleanup

To avoid ongoing costs, destroy the EKS cluster:

```bash
# Destroy EKS resources
terraform destroy -target=module.eks_cluster
terraform destroy -target=module.vpc_eks

# Or destroy everything
terraform destroy
```

## Security Considerations

1. **Network Security:**
   - Use private subnets for worker nodes in production
   - Implement proper security group rules
   - Consider using AWS PrivateLink for API access

2. **IAM Security:**
   - Use least privilege principle
   - Enable IAM roles for service accounts (IRSA)
   - Regularly rotate access keys

3. **Cluster Security:**
   - Enable encryption at rest
   - Use AWS KMS for secrets encryption
   - Implement network policies

## Next Steps

1. **Production Setup:**
   - Use private subnets for worker nodes
   - Enable NAT Gateway for outbound internet access
   - Implement proper monitoring and alerting
   - Set up CI/CD pipelines

2. **Advanced Features:**
   - AWS Fargate for serverless containers
   - AWS App Mesh for service mesh
   - AWS X-Ray for distributed tracing
   - AWS CloudWatch Container Insights

## Support

For issues and questions:
1. Check AWS EKS documentation
2. Review Terraform AWS provider documentation
3. Check CloudWatch logs for detailed error messages
4. Verify IAM permissions and policies
