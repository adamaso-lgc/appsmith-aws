output "cluster_id" {
  description   = "EKS cluster ID."
  value         = module.eks.cluster_id
}

output "eks_workers_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "output_role_name" {
  value = aws_iam_role.node_role.name
}
