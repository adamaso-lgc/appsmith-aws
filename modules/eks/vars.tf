variable "name" {
  description = "The name of the EKS cluster"
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