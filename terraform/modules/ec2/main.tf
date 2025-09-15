# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance
resource "aws_instance" "main" {
  count = var.instance_count

  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  availability_zone      = var.availability_zone

  user_data = var.user_data

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.delete_root_volume_on_termination
    encrypted             = var.encrypt_root_volume
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      volume_type           = ebs_block_device.value.volume_type
      volume_size           = ebs_block_device.value.volume_size
      delete_on_termination = ebs_block_device.value.delete_on_termination
      encrypted             = ebs_block_device.value.encrypted
      iops                  = ebs_block_device.value.iops
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-${count.index + 1}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP (optional)
resource "aws_eip" "main" {
  count = var.create_eip ? var.instance_count : 0

  instance = aws_instance.main[count.index].id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-eip-${count.index + 1}"
  })
}

# Security Group (if not provided)
resource "aws_security_group" "main" {
  count = length(var.security_group_ids) == 0 ? 1 : 0

  name_prefix = "${var.name}-sg-"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-security-group"
  })

  lifecycle {
    create_before_destroy = true
  }
}
