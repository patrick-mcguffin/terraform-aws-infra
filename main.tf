terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source              = "./modules/networking"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  availability_zones  = var.availability_zones
  environment         = var.environment
  project_name        = var.project_name
}

module "security" {
  source       = "./modules/security"
  vpc_id       = module.networking.vpc_id
  environment  = var.environment
  project_name = var.project_name
  my_ip        = var.my_ip
}

module "database" {
  source                = "./modules/database"
  private_subnet_id     = module.networking.private_subnet_id
  private_subnet_id_2   = module.networking.private_subnet_id_2
  rds_sg_id             = module.security.rds_sg_id
  db_instance_class     = var.db_instance_class
  db_name               = var.db_name
  db_allocated_storage  = var.db_allocated_storage
  db_password_secret_id = var.db_password_secret_id
  db_username_secret_id = var.db_username_secret_id
  environment           = var.environment
  project_name          = var.project_name
}

module "compute" {
  source                    = "./modules/compute"
  public_subnet_id          = module.networking.public_subnet_id
  private_subnet_id         = module.networking.private_subnet_id
  nginx_sg_id               = module.security.nginx_sg_id
  web_sg_id                 = module.security.web_sg_id
  ec2_instance_profile_name = module.security.ec2_instance_profile_name
  instance_type             = var.instance_type
  ami_id                    = var.ami_id
  key_pair_name             = var.key_pair_name
  rds_endpoint              = module.database.rds_endpoint
  rds_port                  = module.database.rds_port
  db_name                   = module.database.db_name
  environment               = var.environment
  project_name              = var.project_name
}
