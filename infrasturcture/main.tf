module "vpc" {
  source               = "./modules/vpc"
  Name                 = lookup(var.vpc_vars, "name")
  cidr_block           = lookup(var.vpc_vars, "cidr_block")
  subnet_public        = lookup(var.vpc_vars, "subnet_public")
  subnet_private       = lookup(var.vpc_vars, "subnet_private")
  subnet_private_db    = lookup(var.vpc_vars, "subnet_private_db")
  region               = lookup(var.vpc_vars, "region")
  route_tables_public  = var.route_tables_public
  route_tables_private  = var.route_tables_private
  route_tables_private_db  = var.route_tables_private_db
  tags                 = var.default_tags
}

module "securityGroups" {
  count                = length(var.security_groups)
  source               = "./modules/securityGroups"
  name                 = var.security_groups[count.index]
  vpcId                = module.vpc.vpcId
  vpcCidr              = lookup(var.vpc_vars, "cidr_block")
  tags                 = var.default_tags
}

module "eksIamRole" {
  source = "./modules/eksIamRole"
  tags   = var.default_tags  
}


module "rds" {
  count = length(var.rds_data)
  source = "./modules/rds"
  tags   = var.default_tags
  vpcId  = module.vpc.vpcId
  vpcCidr = lookup(var.vpc_vars, "cidr_block")
  data  = var.rds_data[count.index]
  dbSubnets = module.vpc.dbSubnets
}


module "neptune" {
  count = length(var.neptune_data)
  source = "./modules/neptunedb"
  tags   = var.default_tags
  vpcId  = module.vpc.vpcId
  vpcCidr = lookup(var.vpc_vars, "cidr_block")
  data  = var.neptune_data[count.index]
  dbSubnets = module.vpc.dbSubnets
}

module "elasticache" {
  count = length(var.elasticache_data)
  source = "./modules/elasticache"
  tags   = var.default_tags
  vpcId  = module.vpc.vpcId
  vpcCidr = lookup(var.vpc_vars, "cidr_block")
  data  = var.elasticache_data[count.index]
  dbSubnets = module.vpc.dbSubnets
}

module "msk" {
  count = length(var.msk_data)
  source = "./modules/msk"
  tags   = var.default_tags
  vpcId  = module.vpc.vpcId
  vpcCidr = lookup(var.vpc_vars, "cidr_block")
  data  = var.msk_data[count.index]
  dbSubnets = module.vpc.dbSubnets
}