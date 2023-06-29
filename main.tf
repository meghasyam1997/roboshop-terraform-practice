module "vpc" {
  source = "git::https://github.com/meghasyam1997/tf-module-vpc-practice.git"

  for_each = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets = each.value["subnets"]
  tags = local.tags
  env = var.env
}