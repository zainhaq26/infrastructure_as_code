# Free Tier ECS Cluster Configuration
# Deploy with: terraform apply -target=module.ecs_free_tier

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
