locals {
  cluster_name    = "${var.environment}-eks-${var.name}"
}

resource "aws_security_group" "appsmith_git_sg" {
  name          = "${var.name}-git-sg"
  description   = "Security group for Appsmith application on EKS with SSH outbound"
  vpc_id        = var.vpc_id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access to the internet for GitHub connections"
  }

  tags = {
    Name = "AppsmithSecurityGroup"
  }
}

module "eks" {
  source              = "terraform-aws-modules/eks/aws"
  version             = "18.29.1"
  
  cluster_name        = local.cluster_name
  cluster_version     = "1.23"
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids

  enable_irsa         = true

  cluster_tags = {
    ApplicationName = var.name
    Environment     = var.environment
  }

  eks_managed_node_groups = {
    appsmith_nodes = {

      desired_capacity        = 2
      max_capacity            = 3
      min_capacity            = 1

      create_iam_role         = false
      iam_role_arn            = aws_iam_role.node_role.arn    

      instance_type           = "m5.large"
      subnets                 = var.subnet_ids

      vpc_security_group_ids  = [aws_security_group.appsmith_git_sg.id]
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

