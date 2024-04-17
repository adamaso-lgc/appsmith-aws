variable "name" {
  description = "The name of the EFS volume"
  type        = string
}

variable "environment" {
  description = "The environment of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "eks_node_security_group_ids" {
  description = "List of security group IDs for EKS nodes that will access EFS"
  type        = list(string)
}
