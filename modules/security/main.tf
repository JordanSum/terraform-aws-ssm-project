terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.4.0"
      configuration_aliases = [aws.west, aws.east]
    }
  }
}

#Define IAM role that allows EC2 instances to access SSM
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2_ssm_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "ec2_ssm_instance_profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# Create a security group for VPC endpoints - West Region
resource "aws_security_group" "vpc_endpoints_sg_west" {
  provider    = aws.west
  name_prefix = "vpc_endpoints_sg_west"
  description = "Security group for VPC endpoints in West region"
  vpc_id      = var.vpc_id_west

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_west]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc_endpoints_sg_west"
  }
}

# Create a security group for VPC endpoints - East Region
resource "aws_security_group" "vpc_endpoints_sg_east" {
  provider    = aws.east
  name_prefix = "vpc_endpoints_sg_east"
  description = "Security group for VPC endpoints in East region"
  vpc_id      = var.vpc_id_east

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_east]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc_endpoints_sg_east"
  }
}

# VPC Endpoint for SSM - West Region
resource "aws_vpc_endpoint" "ssm_west" {
  provider            = aws.west
  vpc_id              = var.vpc_id_west
  service_name        = "com.amazonaws.us-west-2.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.subnet_one_west, var.subnet_two_west]
  security_group_ids  = [aws_security_group.vpc_endpoints_sg_west.id]
  
  private_dns_enabled = true
  
  tags = {
    Name = "ssm_vpc_endpoint_west"
  }
}

# VPC Endpoint for SSM - East Region
resource "aws_vpc_endpoint" "ssm_east" {
  provider            = aws.east
  vpc_id              = var.vpc_id_east
  service_name        = "com.amazonaws.us-east-2.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.subnet_one_east, var.subnet_two_east]
  security_group_ids  = [aws_security_group.vpc_endpoints_sg_east.id]
  
  private_dns_enabled = true
  
  tags = {
    Name = "ssm_vpc_endpoint_east"
  }
}

# VPC Endpoint for SSM Messages - West Region
resource "aws_vpc_endpoint" "ssmmessages_west" {
  provider            = aws.west
  vpc_id              = var.vpc_id_west
  service_name        = "com.amazonaws.us-west-2.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.subnet_one_west, var.subnet_two_west]
  security_group_ids  = [aws_security_group.vpc_endpoints_sg_west.id]
  
  private_dns_enabled = true
  
  tags = {
    Name = "ssmmessages_vpc_endpoint_west"
  }
}

# VPC Endpoint for SSM Messages - East Region
resource "aws_vpc_endpoint" "ssmmessages_east" {
  provider            = aws.east
  vpc_id              = var.vpc_id_east
  service_name        = "com.amazonaws.us-east-2.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.subnet_one_east, var.subnet_two_east]
  security_group_ids  = [aws_security_group.vpc_endpoints_sg_east.id]
  
  private_dns_enabled = true
  
  tags = {
    Name = "ssmmessages_vpc_endpoint_east"
  }
}

# VPC Endpoint for EC2 Messages - West Region
resource "aws_vpc_endpoint" "ec2messages_west" {
  provider            = aws.west
  vpc_id              = var.vpc_id_west
  service_name        = "com.amazonaws.us-west-2.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.subnet_one_west, var.subnet_two_west]
  security_group_ids  = [aws_security_group.vpc_endpoints_sg_west.id]
  
  private_dns_enabled = true
  
  tags = {
    Name = "ec2messages_vpc_endpoint_west"
  }
}

# VPC Endpoint for EC2 Messages - East Region
resource "aws_vpc_endpoint" "ec2messages_east" {
  provider            = aws.east
  vpc_id              = var.vpc_id_east
  service_name        = "com.amazonaws.us-east-2.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.subnet_one_east, var.subnet_two_east]
  security_group_ids  = [aws_security_group.vpc_endpoints_sg_east.id]
  
  private_dns_enabled = true
  
  tags = {
    Name = "ec2messages_vpc_endpoint_east"
  }
}

# Create a Security Group for instances - West Region
resource "aws_security_group" "instance_SG_west" {
  provider    = aws.west
  name        = "Instance_SG_West"
  description = "Configuration of SG for ec2 in West region"
  vpc_id      = var.vpc_id_west

  # Allow outbound HTTPS for SSM communication
  egress {
    description = "HTTPS to VPC endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_west]
  }

  # Allow all outbound traffic (can be restricted later)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" 
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "HTTP from local VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_west]
  }

  ingress {
    description = "HTTP from peer VPC (East)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_east]
  }

  ingress {
    description = "HTTPS from local VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_west]
  }

  ingress {
    description = "HTTPS from peer VPC (East)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_east]
  }

  tags = {
    Name = "Instance_SG_West"
  }
}

# Create a Security Group for instances - East Region
resource "aws_security_group" "instance_SG_east" {
  provider    = aws.east
  name        = "Instance_SG_East"
  description = "Configuration of SG for ec2 in East region"
  vpc_id      = var.vpc_id_east

  # Allow outbound HTTPS for SSM communication
  egress {
    description = "HTTPS to VPC endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_east]
  }

  # Allow all outbound traffic (can be restricted later)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "HTTPS from local VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_east]
  }

  ingress {
    description = "HTTPS from peer VPC (West)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_west]
  }

  ingress {
    description = "HTTP from local VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_east]
  }

  ingress {
    description = "HTTP from peer VPC (West)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_west]
  }

  tags = {
    Name = "Instance_SG_East"
  }
}
