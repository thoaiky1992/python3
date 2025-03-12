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
    key    = "python/v.1.0.0.tfstate"  # Đường dẫn key với biến version
    region = "ap-southeast-1"
  }
}

data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    bucket = "thoaiky-terraform-state" # Tên bucket đã tạo
    key    = "python/common.tfstate"   # Đường dẫn key với biến version
    region = "ap-southeast-1"
  }
}

module "ecs_cluster" {
  source      = "../modules/ecs-cluster"
  tag_version = var.tag_version
}

module "load_balancer" {
  source          = "../modules/load-balancer"
  security_groups = data.terraform_remote_state.common.outputs.security_groups
  subnet_ids      = data.terraform_remote_state.common.outputs.subnets.subnet_ids
  vpc_id          = data.terraform_remote_state.common.outputs.vpc.id
  tag_version     = var.tag_version
}

module "launch_template" {
  source                         = "../modules/launch-template"
  ecs_instance_role_profile_name = data.terraform_remote_state.common.outputs.iam_role.ecs_instance_role.profile_name
  tag_version                    = var.tag_version
  ecs_cluster                    = module.ecs_cluster
  key_pair_name                  = var.key_pair_name
  security_groups                = data.terraform_remote_state.common.outputs.security_groups
  public_subnet_ids              = data.terraform_remote_state.common.outputs.subnets.subnet_ids.public
  private_subnet_ids             = data.terraform_remote_state.common.outputs.subnets.subnet_ids.private
}

module "auto_scaling_group" {
  source             = "../modules/auto-scaling-group"
  public_subnet_ids  = data.terraform_remote_state.common.outputs.subnets.subnet_ids.public
  private_subnet_ids = data.terraform_remote_state.common.outputs.subnets.subnet_ids.private
  launch_template    = module.launch_template
  tag_version        = var.tag_version
}

module "ecs_task_definition" {
  source                  = "../modules/task-definition"
  ecs_task_execution_role = data.terraform_remote_state.common.outputs.iam_role.ecs_task_execution_role
  region                  = var.region
  tag_version             = var.tag_version
  ecr                     = data.terraform_remote_state.common.outputs.ecr
}
module "ecs_service" {
  source              = "../modules/ecs-service"
  ecs_cluster         = module.ecs_cluster
  ecs_task_definition = module.ecs_task_definition
  tag_version         = var.tag_version
  subnets             = data.terraform_remote_state.common.outputs.subnets
  security_groups     = data.terraform_remote_state.common.outputs.security_groups
  service_discovery   = data.terraform_remote_state.common.outputs.service_discovery

  depends_on = [module.ecs_task_definition]
}

# module "auto_scaling_ecs_api_task" {
#   source      = "../modules/auto-scaling-ecs-task"
#   ecs_service = module.ecs_service
#   ecs_cluster = module.ecs_cluster
#   tag_version = var.tag_version
#   depends_on  = [module.ecs_service]
# }
