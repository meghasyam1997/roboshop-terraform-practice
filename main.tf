module "vpc" {
  source = "git::https://github.com/meghasyam1997/tf-module-vpc-practice.git"

  for_each = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets = each.value["subnets"]
  tags = local.tags
  env = var.env
}

#module "app" {
#  source = "git::https://github.com/meghasyam1997/tf-module-app-practice.git"
#
#  for_each = var.app
#  instance_type = each.value["instance_type"]
#  name = each.value["name"]
#}