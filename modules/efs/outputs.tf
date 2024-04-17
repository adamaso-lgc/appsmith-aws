output "efs_id" {
  value = aws_efs_file_system.efs_volume.id
}

output "efs_arn" {
  value = aws_efs_file_system.efs_volume.arn
}

output "mount_target_ids" {
  value = [for mt in aws_efs_mount_target.efs_target  : mt.id]
}

