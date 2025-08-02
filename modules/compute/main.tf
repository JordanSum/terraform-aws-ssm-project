resource "aws_instance" "ssm_test_1" {

    ami           = var.ami_id # change as needed
    instance_type = var.instance_type
    #key_name = "TerraformKey" # Ensure you have created this key pair in AWS
    iam_instance_profile = var.iam_profile

    network_interface {
    network_interface_id = aws_network_interface.NIC1.id
    device_index         = 0
  }
    
    tags = {
        Name = "SSM_Test_Instance_1"
    }
  
}

resource "aws_network_interface" "NIC1" {
  subnet_id       = var.subnet_one
  private_ips     = ["192.168.20.10"]
  security_groups = [var.instance_SG]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "ssm_test_2" {

    ami           = var.ami_id # Using variable instead of hardcoded
    instance_type = var.instance_type
    #key_name = "TerraformKey" # Ensure you have created this key pair in AWS
    iam_instance_profile = var.iam_profile

    network_interface {
    network_interface_id = aws_network_interface.NIC2.id
    device_index         = 0
  }
    
    tags = {
        Name = "SSM_Test_Instance_2"
    }
  
}

resource "aws_network_interface" "NIC2" {
  subnet_id       = var.subnet_two
  private_ips     = ["192.168.30.10"]
  security_groups = [var.instance_SG]

  tags = {
    Name = "Secondary_network_interface"
  }
}