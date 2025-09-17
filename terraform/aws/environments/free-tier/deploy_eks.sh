#!/bin/bash

# EKS Deployment Script for Free Tier Environment
# This script helps deploy EKS cluster with proper configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if AWS CLI is installed
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed. Please install it first."
        exit 1
    fi
    
    # Check if Terraform is installed
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install it first."
        exit 1
    fi
    
    # Check if kubectl is installed
    if ! command -v kubectl &> /dev/null; then
        print_warning "kubectl is not installed. You'll need it to manage the cluster."
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity &> /dev/null; then
        print_error "AWS credentials not configured. Please run 'aws configure' first."
        exit 1
    fi
    
    print_status "Prerequisites check completed."
}

# Display cost warning
show_cost_warning() {
    print_warning "=========================================="
    print_warning "IMPORTANT COST WARNING"
    print_warning "=========================================="
    print_warning "EKS is NOT included in AWS Free Tier!"
    print_warning "This deployment will incur costs:"
    print_warning "- EKS Control Plane: ~$0.10/hour (~$73/month)"
    print_warning "- EC2 instances: varies by type"
    print_warning "- Other resources: load balancers, etc."
    print_warning "=========================================="
    
    read -p "Do you want to continue? (yes/no): " -r
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        print_status "Deployment cancelled."
        exit 0
    fi
}

# Initialize Terraform
init_terraform() {
    print_status "Initializing Terraform..."
    terraform init
}

# Plan deployment
plan_deployment() {
    print_status "Planning EKS deployment..."
    terraform plan -target=module.vpc_eks -target=module.eks_cluster
}

# Deploy VPC first
deploy_vpc() {
    print_status "Deploying VPC for EKS..."
    terraform apply -target=module.vpc_eks -auto-approve
}

# Deploy EKS cluster
deploy_eks() {
    print_status "Deploying EKS cluster..."
    terraform apply -target=module.eks_cluster -auto-approve
}

# Configure kubectl
configure_kubectl() {
    print_status "Configuring kubectl..."
    
    # Get cluster name from terraform output
    CLUSTER_NAME=$(terraform output -raw eks_cluster_id 2>/dev/null || echo "")
    
    if [ -z "$CLUSTER_NAME" ]; then
        print_error "Could not get cluster name from Terraform output."
        return 1
    fi
    
    # Get region from terraform output or use default
    REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-east-1")
    
    print_status "Updating kubeconfig for cluster: $CLUSTER_NAME in region: $REGION"
    aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER_NAME"
    
    # Test connection
    if kubectl get nodes &> /dev/null; then
        print_status "Successfully connected to EKS cluster!"
        kubectl get nodes
    else
        print_warning "Could not connect to cluster. You may need to wait a few minutes for nodes to be ready."
    fi
}

# Show cluster information
show_cluster_info() {
    print_status "Cluster Information:"
    echo "========================"
    
    # Get outputs
    CLUSTER_ID=$(terraform output -raw eks_cluster_id 2>/dev/null || echo "N/A")
    CLUSTER_ENDPOINT=$(terraform output -raw eks_cluster_endpoint 2>/dev/null || echo "N/A")
    VPC_ID=$(terraform output -raw eks_vpc_id 2>/dev/null || echo "N/A")
    
    echo "Cluster ID: $CLUSTER_ID"
    echo "Cluster Endpoint: $CLUSTER_ENDPOINT"
    echo "VPC ID: $VPC_ID"
    echo ""
    
    print_status "Useful commands:"
    echo "  kubectl get nodes          # List cluster nodes"
    echo "  kubectl get pods -A        # List all pods"
    echo "  kubectl create deployment nginx --image=nginx  # Deploy sample app"
    echo ""
}

# Main deployment function
main() {
    print_status "Starting EKS deployment..."
    
    check_prerequisites
    show_cost_warning
    init_terraform
    plan_deployment
    
    print_status "Starting deployment..."
    deploy_vpc
    deploy_eks
    configure_kubectl
    show_cluster_info
    
    print_status "EKS deployment completed successfully!"
    print_warning "Remember to destroy the cluster when done to avoid ongoing costs:"
    print_warning "  terraform destroy -target=module.eks_cluster -target=module.vpc_eks"
}

# Handle script arguments
case "${1:-}" in
    "plan")
        check_prerequisites
        init_terraform
        plan_deployment
        ;;
    "destroy")
        print_warning "This will destroy the EKS cluster and all associated resources."
        read -p "Are you sure? (yes/no): " -r
        if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
            terraform destroy -target=module.eks_cluster -target=module.vpc_eks
        else
            print_status "Destruction cancelled."
        fi
        ;;
    "info")
        show_cluster_info
        ;;
    *)
        main
        ;;
esac
