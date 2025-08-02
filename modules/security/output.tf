output "iam_profile" {
  value = aws_iam_instance_profile.ec2_ssm_instance_profile.name
}

output "instance_SG" {
  value = aws_security_group.instance_SG.id 
}

output "vpc_endpoint_sg" {
  value = aws_security_group.vpc_endpoints_sg.id
  
}