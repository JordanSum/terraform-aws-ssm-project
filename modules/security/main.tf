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

# Create a security group for VPC endpoints
resource "aws_security_group" "vpc_endpoints_sg" {
  name_prefix = "vpc_endpoints_sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc_endpoints_sg"
  }
}

# VPC Endpoint for SSM
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.us-west-2.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.subnet_one, var.subnet_two]
  security_group_ids  = [var.vpc_endpoint_sg]
  
  private_dns_enabled = true
  
  tags = {
    Name = "ssm_vpc_endpoint"
  }
}

# VPC Endpoint for SSM Messages
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.us-west-2.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.subnet_one, var.subnet_two]
  security_group_ids  = [var.vpc_endpoint_sg]
  
  private_dns_enabled = true
  
  tags = {
    Name = "ssmmessages_vpc_endpoint"
  }
}

# VPC Endpoint for EC2 Messages
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.us-west-2.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.subnet_one, var.subnet_two]
  security_group_ids  = [var.vpc_endpoint_sg]
  
  private_dns_enabled = true
  
  tags = {
    Name = "ec2messages_vpc_endpoint"
  }
}

# Create a Security Group for instances
resource "aws_security_group" "instance_SG" {
  name        = "Instance_SG"
  description = "Configuration of SG for ec2"
  vpc_id      = var.vpc_id


  # Allow outbound HTTPS for SSM communication
  egress {
    description = "HTTPS to VPC endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  # Allow all outbound traffic (can be restricted later)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Instance_SG"
  }
}
