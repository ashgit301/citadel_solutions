module "vpc" {
  source = "./modules/nw-vpc"
}

module "ec2" {
  source              = "./modules/ec2"
  vpc_security_group  = [module.vpc.vpc_id]
  subnet_id   = module.vpc.public_subnet_id
}

module "rds" {
  source = "./module/rds"
  db_subnet_group_name = module.vpc.db_subnet_name  
}
