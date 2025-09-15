# EBS Volume
resource "aws_ebs_volume" "main" {
  count = var.create_volume ? 1 : 0

  availability_zone = var.availability_zone
  size              = var.size
  type              = var.type
  iops              = var.iops
  throughput        = var.throughput
  encrypted         = var.encrypted
  kms_key_id        = var.kms_key_id

  tags = merge(var.tags, {
    Name = var.name
  })
}

# EBS Volume Attachment
resource "aws_volume_attachment" "main" {
  count = var.attach_to_instance ? 1 : 0

  device_name = var.device_name
  volume_id   = var.volume_id != "" ? var.volume_id : aws_ebs_volume.main[0].id
  instance_id = var.instance_id
}

# EBS Snapshot
resource "aws_ebs_snapshot" "main" {
  count = var.create_snapshot ? 1 : 0

  volume_id = var.volume_id != "" ? var.volume_id : aws_ebs_volume.main[0].id

  tags = merge(var.tags, {
    Name = "${var.name}-snapshot"
  })
}

# EBS Snapshot Copy
resource "aws_ebs_snapshot_copy" "main" {
  count = var.create_snapshot_copy ? 1 : 0

  source_snapshot_id = var.source_snapshot_id
  source_region      = var.source_region
  description        = var.snapshot_copy_description

  tags = merge(var.tags, {
    Name = "${var.name}-snapshot-copy"
  })
}
