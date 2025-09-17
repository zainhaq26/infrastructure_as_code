# Free Tier Environment - Main Configuration
# This file can be used to deploy all components at once
# Or you can deploy individual components using the separate .tf files

# Uncomment the components you want to deploy:

# EC2 Instance
# module "ec2_free_tier" {
#   source = "../../modules/ec2"
#   name          = "${var.project_name}-free-tier"
#   instance_type = "t2.micro"
#   instance_count = 1
#   root_volume_type = "gp2"
#   root_volume_size = 8
#   create_eip = false
#   ingress_rules = [
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#       description = "SSH access"
#     }
#   ]
#   tags = {
#     Environment = "free-tier"
#     Purpose     = "learning"
#     FreeTier    = "true"
#   }
# }

# EBS Volume
# module "ebs_free_tier" {
#   source = "../../modules/ebs"
#   name = "${var.project_name}-free-tier-volume"
#   size = 20
#   type = "gp2"
#   attach_to_instance = false
#   tags = {
#     Environment = "free-tier"
#     Purpose     = "learning"
#     FreeTier    = "true"
#   }
# }

# ECS Cluster
# module "ecs_free_tier" {
#   source = "../../modules/ecs"
#   cluster_name = "${var.project_name}-free-tier-ecs"
#   cpu           = "256"
#   memory        = "512"
#   desired_count = 1
#   log_retention_in_days = 1
#   tags = {
#     Environment = "free-tier"
#     Purpose     = "learning"
#     FreeTier    = "true"
#   }
# }

# CloudWatch
# module "cloudwatch_free_tier" {
#   source = "../../modules/cloudwatch"
#   log_group_name = "/aws/free-tier/${var.project_name}"
#   log_retention_in_days = 1
#   metric_alarms = {
#     "ec2-cpu-high" = {
#       alarm_name          = "free-tier-ec2-cpu-high"
#       comparison_operator = "GreaterThanThreshold"
#       evaluation_periods  = "2"
#       metric_name         = "CPUUtilization"
#       namespace           = "AWS/EC2"
#       period              = "300"
#       statistic           = "Average"
#       threshold           = "80"
#       alarm_description   = "EC2 CPU usage is high"
#       alarm_actions       = []
#     }
#   }
#   tags = {
#     Environment = "free-tier"
#     Purpose     = "learning"
#     FreeTier    = "true"
#   }
# }

# EKS Cluster
# Note: EKS is NOT included in AWS Free Tier, but this configuration uses minimal resources
# Uncomment the lines below to deploy EKS (will incur costs)
# module "eks_free_tier" {
#   source = "../../modules/eks"
#   cluster_name = "${var.project_name}-eks-cluster"
#   kubernetes_version = "1.28"
#   subnet_ids = module.vpc_eks.public_subnet_ids
#   endpoint_private_access = false
#   endpoint_public_access  = true
#   public_access_cidrs     = ["0.0.0.0/0"]
#   enabled_cluster_log_types = ["api", "audit"]
#   log_retention_in_days     = 1
#   create_node_group = true
#   node_group_name   = "main"
#   capacity_type     = "ON_DEMAND"
#   instance_types    = ["t3.micro"]
#   desired_size = 1
#   max_size     = 1
#   min_size     = 1
#   max_unavailable_percentage = 25
#   tags = {
#     Environment = "free-tier"
#     Purpose     = "learning"
#     FreeTier    = "true"
#   }
# }