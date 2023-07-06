env               = "dev"
kms_arn           = "arn:aws:kms:us-east-1:844746520101:key/f2e4231a-4405-4fcc-9d18-bb7c5e81348f"
bastion_cidr      = ["172.31.13.110/32"]
default_vpc_id    = "vpc-02fd95dec0b93d08a"
default_vpc_cidr  = "172.31.0.0/16"
default_vpc_rt_id = "rtb-04788961f7eb75f09"

vpc = {
  main = {
    cidr_block = "10.0.0.0/16"
    subnets    = {
      public = {
        name       = "public"
        cidr_block = ["10.0.0.0/24", "10.0.1.0/24"]
        azs        = ["us-east-1a", "us-east-1b"]
      }
      web = {
        name       = "web"
        cidr_block = ["10.0.2.0/24", "10.0.3.0/24"]
        azs        = ["us-east-1a", "us-east-1b"]
      }
      app = {
        name       = "app"
        cidr_block = ["10.0.4.0/24", "10.0.5.0/24"]
        azs        = ["us-east-1a", "us-east-1b"]
      }
      db = {
        name       = "db"
        cidr_block = ["10.0.6.0/24", "10.0.7.0/24"]
        azs        = ["us-east-1a", "us-east-1b"]
      }
    }
  }
}

app = {
  frontend = {
    name             = "frontend"
    instance_type    = "t3.small"
    subnet_name      = "web"
    allow_app_cidr   = "public"
    desired_capacity = 2
    max_size         = 10
    min_size         = 2
  }
  catalogue = {
    name             = "catalogue"
    instance_type    = "t3.small"
    subnet_name      = "app"
    allow_app_cidr   = "web"
    desired_capacity = 2
    max_size         = 10
    min_size         = 2
  }
  #  cart = {
  #    name           = "cart"
  #    instance_type  = "t3.small"
  #    subnet_name    = "app"
  #    allow_app_cidr = "web"
  #  }
  #  user = {
  #    name           = "user"
  #    instance_type  = "t3.small"
  #    subnet_name    = "app"
  #    allow_app_cidr = "web"
  #  }
  #  shipping = {
  #    name           = "shipping"
  #    instance_type  = "t3.small"
  #    subnet_name    = "app"
  #    allow_app_cidr = "web"
  #  }
  #  payment = {
  #    name           = "payment"
  #    instance_type  = "t3.small"
  #    subnet_name    = "app"
  #    allow_app_cidr = "web"
  #  }
}
#  docdb = {
#    main = {
#      name           = "docdb"
#      engine         = "docdb"
#      engine_version = "4.0.0"
#      instance_class = "db.t3.medium"
#      instance_count = 1
#      subnet_name    = "db"
#      allow_db_cidr  = "app"
#      port           = 27017
#    }
#  }