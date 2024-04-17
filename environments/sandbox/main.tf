data "aws_vpc" "default" {
  default = true
}

locals {
  service_name    = "appsmith"
  environment     = "sandbox"
}

module "eks_appsmith" {
  source      = "../../modules/eks"
 
  name        = local.service_name
  environment = local.environment
  vpc_id      = data.aws_vpc.default.id
  subnet_ids  = var.subnet_ids
}

/* module "efs_appsmith" {
  source                      = "../../modules/efs"

  name                        = local.service_name
  environment                 = local.environment
  vpc_id                      = data.aws_vpc.default.id
  subnet_ids                  = var.subnet_ids
  eks_node_security_group_ids = [module.eks_appsmith.eks_workers_security_group_id]
} */

