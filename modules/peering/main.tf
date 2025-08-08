terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 6.4.0"
      configuration_aliases = [aws.west2, aws.east]
    }
  }
}

#VPC Peering Connection (Initiate from us-west-2)

resource "aws_vpc_peering_connection" "main" {
  provider    = aws.west2
  vpc_id      = var.vpc_id_west
  peer_vpc_id = var.vpc_id_east
  peer_region = "us-east-2"

  tags = {
    Name = "${var.project_name}-vpc-peering"
  }
}

# Accept VPC Peering Connection in the East Region
resource "aws_vpc_peering_connection_accepter" "main" {
  provider                  = aws.east
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  auto_accept               = true

  tags = {
    Name = "${var.project_name}-vpc-peering-accept"
  }
}

# Route Table for West Region
resource "aws_route" "west_to_east" {
  provider                  = aws.west2
  count                     = length(var.route_table_ids_west)
  route_table_id            = var.route_table_ids_west[count.index]
  destination_cidr_block    = var.cidr_block_east
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

# Route Table for East Region
resource "aws_route" "east_to_west" {
  provider                  = aws.east
  count                     = length(var.route_table_ids_east)
  route_table_id            = var.route_table_ids_east[count.index]
  destination_cidr_block    = var.cidr_block_west
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.main.id
}