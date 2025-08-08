output "iam_profile" {
  value = aws_iam_instance_profile.ec2_ssm_instance_profile.name
}

output "backup_iam_role_arn" {
  value = aws_iam_role.backup_selection_role.arn
}

output "instance_SG_west" {
  value = aws_security_group.instance_SG_west.id
}

output "instance_SG_east" {
  value = aws_security_group.instance_SG_east.id
}

output "vpc_endpoint_sg_west" {
  value = aws_security_group.vpc_endpoints_sg_west.id
}

output "vpc_endpoint_sg_east" {
  value = aws_security_group.vpc_endpoints_sg_east.id
}