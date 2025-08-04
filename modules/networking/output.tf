output "vpc_id_west" {
  value = aws_vpc.vpc_west.id
}

output "vpc_id_east" {
  value = aws_vpc.vpc_east.id
}

output "subnet_one_west" {
  value = aws_subnet.subnet_one_west.id
}

output "subnet_two_west" {
  value = aws_subnet.subnet_two_west.id
}

output "subnet_one_east" {
  value = aws_subnet.subnet_one_east.id
}

output "subnet_two_east" {
  value = aws_subnet.subnet_two_east.id
}