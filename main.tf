terraform {
  required_version = ">= 1.0.0"
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
  alias  = "west"
}

provider "aws" {
  region = "us-east-2"
  alias  = "east"
}

module "compute" {
    source = "./modules/compute"
    ami_id_west = var.ami_id_west
    ami_id_east = var.ami_id_east
    instance_type = var.instance_type
    subnet_one_west = module.networking.subnet_one_west
    subnet_two_west = module.networking.subnet_two_west
    subnet_one_east = module.networking.subnet_one_east
    subnet_two_east = module.networking.subnet_two_east
    iam_profile = module.security.iam_profile
    instance_SG_west = module.security.instance_SG_west
    instance_SG_east = module.security.instance_SG_east
    
    providers = {
      aws.west = aws.west
      aws.east = aws.east
    }
}

module "networking" {
    source = "./modules/networking"
    cidr_block = var.cidr_block
    subnet_one_west = var.subnet_one_west
    subnet_two_west = var.subnet_two_west
    subnet_one_east = var.subnet_one_east
    subnet_two_east = var.subnet_two_east
    project_name = var.project_name
    
    providers = {
      aws.west = aws.west
      aws.east = aws.east
    }
}

module "security" {
    source = "./modules/security"
    vpc_id_west = module.networking.vpc_id_west
    vpc_id_east = module.networking.vpc_id_east
    cidr_block = var.cidr_block
    subnet_one_west = module.networking.subnet_one_west
    subnet_two_west = module.networking.subnet_two_west
    subnet_one_east = module.networking.subnet_one_east
    subnet_two_east = module.networking.subnet_two_east
    
    providers = {
      aws.west = aws.west
      aws.east = aws.east
    }
}