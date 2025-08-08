terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 6.4.0"
      configuration_aliases = [aws.west2, aws.east]
    }
  }
}

#VPC Environment Configuration West Coast

resource "aws_vpc" "vpc_west" {
  provider             = aws.west2
  cidr_block           = var.cidr_block_west
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-west"
  }
}

#subnet environment configuration, West Coast

resource "aws_subnet" "subnet_one_west" {
  provider                = aws.west2
  vpc_id                  = aws_vpc.vpc_west.id
  cidr_block              = var.subnet_one_west
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ssm_subnet_one_west"
  }
}

resource "aws_subnet" "subnet_two_west" {
  provider                = aws.west2
  vpc_id                  = aws_vpc.vpc_west.id
  cidr_block              = var.subnet_two_west
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "ssm_subnet_two_west"
  }
}

#VPC Environemnt Configuration East Coast

resource "aws_vpc" "vpc_east" {
  provider             = aws.east
  cidr_block           = var.cidr_block_east
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-east"
  }
}

#subnet environment configuration, East Coast

resource "aws_subnet" "subnet_one_east" {
  provider                = aws.east
  vpc_id                  = aws_vpc.vpc_east.id
  cidr_block              = var.subnet_one_east
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ssm_subnet_one_east"
  }
}

resource "aws_subnet" "subnet_two_east" {
  provider                = aws.east
  vpc_id                  = aws_vpc.vpc_east.id
  cidr_block              = var.subnet_two_east
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "ssm_subnet_two_east"
  }
}

resource "aws_internet_gateway" "igw_east" {
  provider = aws.east
  vpc_id   = aws_vpc.vpc_east.id

  tags = {
    Name = "igw_east"
  }
}

resource "aws_route_table" "public_east" {
  provider = aws.east
  vpc_id   = aws_vpc.vpc_east.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_east.id
  }

  tags = {
    Name = "public_route_table_east"
  }
}

# Route Table Associations

resource "aws_route_table_association" "east_subnet_one" {
  provider       = aws.east
  subnet_id      = aws_subnet.subnet_one_east.id
  route_table_id = aws_route_table.public_east.id
}

resource "aws_route_table_association" "east_subnet_two" {
  provider       = aws.east
  subnet_id      = aws_subnet.subnet_two_east.id
  route_table_id = aws_route_table.public_east.id
}

# Route table for west region
resource "aws_route_table" "public_west" {
  provider = aws.west2
  vpc_id   = aws_vpc.vpc_west.id

  tags = {
    Name = "${var.project_name}-rt-west"
  }
}

# Associate west subnets with west route table
resource "aws_route_table_association" "west_subnet_one" {
  provider       = aws.west2
  subnet_id      = aws_subnet.subnet_one_west.id
  route_table_id = aws_route_table.public_west.id
}

resource "aws_route_table_association" "west_subnet_two" {
  provider       = aws.west2
  subnet_id      = aws_subnet.subnet_two_west.id
  route_table_id = aws_route_table.public_west.id
}