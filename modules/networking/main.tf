#VPC Environment Configuration

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = var.project_name # Change to your own VPC name
  }
}

#subnet environment configuration

resource "aws_subnet" "subnet_one" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.subnet_one
    availability_zone = "us-west-2a"
    
    tags = {
        Name = "ssm_subnet_one"
    }
}

resource "aws_subnet" "subnet_two" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.subnet_two
    availability_zone = "us-west-2b"
    
    tags = {
        Name = "ssm_subnet_two"
    }
}
