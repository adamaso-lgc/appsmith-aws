locals {
  sg_name   =  "${var.name}-efs-sg"
  efs_name  = "${var.environment}-efs-${var.name}"
}

resource "aws_security_group" "efs_sg" {
  name        = local.sg_name
  description = "Security group for Appsmith EFS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "NFS traffic from eks sg"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = var.eks_node_security_group_ids
  }


  tags = {
    Name            = local.sg_name
    Environment     = var.environment
  }
}

resource "aws_efs_file_system" "efs_volume" {
  creation_token    = local.efs_name
  performance_mode  = "generalPurpose"
  throughput_mode   = "bursting"
  encrypted         = true
  tags = {
    Name            = local.efs_name
    Environment     = var.environment
  }
}

resource "aws_efs_mount_target" "efs_target" {
  for_each        = toset(var.subnet_ids)
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id]
}

