# Free Tier EBS Volume Configuration
# Deploy with: terraform apply -target=aws_ebs_volume.free_tier

# EBS Volume
resource "aws_ebs_volume" "free_tier" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 20  # Within 30GB limit
  type              = "gp2"  # Free tier eligible
  encrypted         = false

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
    Name        = "${var.project_name}-free-tier-volume"
  }
}
