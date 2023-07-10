module "vpc" {
  source = "git::https://github.com/meghasyam1997/tf-module-vpc-practice.git"

  for_each          = var.vpc
  cidr_block        = each.value["cidr_block"]
  subnets           = each.value["subnets"]
  tags              = local.tags
  env               = var.env
  default_vpc_id    = var.default_vpc_id
  default_vpc_cidr  = var.default_vpc_cidr
  default_vpc_rt_id = var.default_vpc_rt_id
}

module "app" {
  source = "git::https://github.com/meghasyam1997/tf-module-app-practice.git"

  for_each         = var.app
  instance_type    = each.value["instance_type"]
  name             = each.value["name"]
  desired_capacity = each.value["desired_capacity"]
  max_size         = each.value["max_size"]
  min_size         = each.value["min_size"]

  subnet_ids     = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  vpc_id         = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  allow_app_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_app_cidr"], null), "subnet_cidrs", null)

  env          = var.env
  bastion_cidr = var.bastion_cidr
  tags         = local.tags
}

module "docdb" {
  source = "git::https://github.com/meghasyam1997/practice-tf-module-docdb.git"

  for_each       = var.docdb
  name           = each.value["name"]
  engine         = each.value["engine"]
  engine_version = each.value["engine_version"]
  instance_count = each.value["instance_count"]
  instance_class = each.value["instance_class"]
  port           = each.value["port"]

  subnets       = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)

  tags    = local.tags
  env     = var.env
  vpc_id  = local.vpc_id
  kms_arn = var.kms_arn

}

module "rds" {
  source = "git::https://github.com/meghasyam1997/practice-tf-module-rds.git"

  for_each       = var.rds
  name           = each.value["name"]
  engine         = each.value["engine"]
  engine_version = each.value["engine_version"]
  instance_count = each.value["instance_count"]
  instance_class = each.value["instance_class"]
  port           = each.value["port"]

  subnets       = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)

  tags    = local.tags
  env     = var.env
  vpc_id  = local.vpc_id
  kms_arn = var.kms_arn

}

module "elasticache" {
  source = "git::https://github.com/meghasyam1997/practice-tf-module-elastic-cache.git"

  for_each                = var.elasticache
  name                    = each.value["name"]
  engine                  = each.value["engine"]
  engine_version          = each.value["engine_version"]
  node_type               = each.value["node_type"]
  num_node_groups         = each.value["num_node_groups"]
  replicas_per_node_group = each.value["replicas_per_node_group"]
  port                    = each.value["port"]

  subnets       = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)

  tags    = local.tags
  env     = var.env
  vpc_id  = local.vpc_id
  kms_arn = var.kms_arn

}

module "rabbitmq" {
  source = "git::https://github.com/meghasyam1997/practice-tf-module-rabbitmq.git"

  for_each      = var.rabbitmq
  subnets       = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
  instance_type = each.value["instance_type"]

  name         = each.value["name"]
  port         = each.value["port"]
  tags         = local.tags
  env          = var.env
  vpc_id       = local.vpc_id
  kms_arn      = var.kms_arn
  bastion_cidr = var.bastion_cidr
  }

module "alb" {
  source = "git::https://github.com/meghasyam1997/practice-tf-module-alb.git"

  for_each = var.alb
  name     = each.value["name"]
  internal = each.value["internal"]

  subnets        = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  vpc_id         = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  allow_alb_cidr = each.value["name"] == "public" ? ["0.0.0.0/0"]:lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_alb_cidr"], null), "subnet_cidrs", null)

  env  = var.env
  tags = local.tags
}



