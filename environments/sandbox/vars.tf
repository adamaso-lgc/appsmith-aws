variable "aws_region" {
  description = "AWS region for the resources"
  type        = string
  default     = "us-east-1" 
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster"
  type        = list(string)
}