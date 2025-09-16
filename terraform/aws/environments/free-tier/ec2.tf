# Free Tier EC2 Instance Configuration
# Deploy with: terraform apply -target=aws_instance.free_tier

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

# local laptops ssh key
resource "aws_key_pair" "default" {
  key_name   = "my-key-pair"
  public_key = var.ssh_public_key
}

# EC2 Instance
# Create key pair in AWS
# aws ec2 create-key-pair --key-name my-key-pair --query 'KeyMaterial' --output text > my-key-pair.pem
# chmod 400 my-key-pair.pem
resource "aws_instance" "free_tier" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2 AMI (us-east-1)
  instance_type = "t3.micro"  # Free tier eligible
  key_name = aws_key_pair.default.key_name  # You'll need to create this key pair

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
