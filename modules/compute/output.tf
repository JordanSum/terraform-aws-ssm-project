output "west_instance_1_private_ip" {
  description = "Private IP of West Region Instance 1"
  value       = aws_network_interface.NIC1.private_ip
}

output "west_instance_2_private_ip" {
  description = "Private IP of West Region Instance 2"
  value       = aws_network_interface.NIC2.private_ip
}

output "east_instance_1_private_ip" {
  description = "Private IP of East Region Instance 1"
  value       = aws_network_interface.NIC3.private_ip
}

output "east_instance_2_private_ip" {
  description = "Private IP of East Region Instance 2"
  value       = aws_network_interface.NIC4.private_ip
}

output "east_instance_1_public_ip" {
  description = "Public IP of East Region Instance 1"
  value       = aws_eip.eip_east_1.public_ip
}

output "east_instance_2_public_ip" {
  description = "Public IP of East Region Instance 2"  
  value       = aws_eip.eip_east_2.public_ip
}
