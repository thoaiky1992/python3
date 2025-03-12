provider "aws" {
  region = var.region
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
  backend "s3" {
    bucket = "thoaiky-terraform-state" # Tên bucket đã tạo
    key    = "python/common.tfstate"   # Đường dẫn key với biến version
    region = "ap-southeast-1"
  }
}

module "vpc" {
  source      = "./00.vpc"
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}

module "iam_role" {
  source      = "./01.iam-role"
  environment = var.environment
}

module "subnets" {
  source      = "./02.subnet"
  vpc_id      = module.vpc.id
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  region      = var.region
}

module "igw" {
  source      = "./03.igw"
  vpc_id      = module.vpc.id
  environment = var.environment
}

module "nat" {
  source            = "./04.nat"
  vpc_id            = module.vpc.id
  public_subnet_ids = module.subnets.subnet_ids.public
  environment       = var.environment
}

module "route_table" {
  source      = "./05.route-table"
  vpc_id      = module.vpc.id
  igw_id      = module.igw.id
  subnet_ids  = module.subnets.subnet_ids
  nat_id      = module.nat.id
  environment = var.environment
}

module "network_acls" {
  source             = "./06.network-acls"
  private_subnet_ids = module.subnets.subnet_ids.public
  public_subnet_ids  = module.subnets.subnet_ids.private
  vpc_id             = module.vpc.id
  environment        = var.environment
}

module "security_group" {
  source      = "./07.security-group"
  vpc_id      = module.vpc.id
  environment = var.environment
}

module "bastion_host" {
  source            = "./08.bastion-host"
  key_name          = var.key_pair_name
  security_group_id = module.security_group.list["bastion-host-security-group"].id
  subnet_id         = module.subnets.subnet_ids.public[0]
  environment       = var.environment
  region            = var.region
}

module "ecr" {
  source      = "./09.elastic-container-registry"
  environment = var.environment
}

module "service_discovery" {
  source      = "./10.service-discovery"
  environment = var.environment
  vpc_id      = module.vpc.id
}



