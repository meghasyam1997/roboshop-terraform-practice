module "vpc" {
  source = "git::https://github.com/meghasyam1997/tf-module-vpc-practice.git"

  for_each = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets = each.value["subnets"]
  tags = local.tags
  env = var.env
}

module "docdb" {
  source = "git::https://github.com/meghasyam1997/practice-tf-module-docdb.git"

  for_each       = var.docdb
  name           = each.value["name"]
  engine         = each.value["engine"]
  engine_version = each.value["engine_version"]
  instance_count = each.value["instance_count"]
  instance_class = each.value["instance_class"]
  port = each.value["port"]

  subnets = lookup(lookup(lookup(lookup(module.vpc,"main",null),"subnets",null),each.value["subnet_name"],null),"subnet_ids",null)
  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc,"main",null),"subnets",null),each.value["allow_db_cidr"],null),"subnet_cidrs",null)

  tags = local.tags
  env = var.env
  vpc_id = local.vpc_id
  kms_arn = var.kms_arn

}

#module "app" {
#  source = "git::https://github.com/meghasyam1997/tf-module-app-practice.git"
#
#  for_each = var.app
#  instance_type = each.value["instance_type"]
#  subnet_ids = lookup(lookup(lookup(lookup(module.vpc,"main",null),"subnets",null),each.value["subnet_name"],null),"subnet_ids",null)
#}