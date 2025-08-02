terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.4.0"
    }
  }
}

#Configure AWS Provider

provider "aws" {
  region = "us-west-2"
  
}

module "compute" {
    source = "./modules/compute"
    ami_id = var.ami_id
    instance_type = var.instance_type
    subnet_one = module.networking.subnet_one
    subnet_two = module.networking.subnet_two
    vpc_id = module.networking.vpc_id
    iam_profile = module.security.iam_profile
    instance_SG = module.security.instance_SG
}

module "networking" {
    source = "./modules/networking"
    cidr_block = var.cidr_block
    subnet_one = var.subnet_one
    subnet_two = var.subnet_two
    project_name = var.project_name
}

module "security" {
    source = "./modules/security"
    vpc_id = module.networking.vpc_id
    cidr_block = var.cidr_block
    subnet_one = module.networking.subnet_one
    subnet_two = module.networking.subnet_two
    vpc_endpoint_sg = module.security.vpc_endpoint_sg
}