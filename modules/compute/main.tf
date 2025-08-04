terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.4.0"
      configuration_aliases = [aws.west, aws.east]
    }
  }
}

resource "aws_instance" "ssm_test_1" {
    provider         = aws.west
    ami              = var.ami_id_west
    instance_type    = var.instance_type
    iam_instance_profile = var.iam_profile

    network_interface {
        network_interface_id = aws_network_interface.NIC1.id
        device_index         = 0
    }
    
    tags = {
        Name = "SSM_Test_Instance_1_west"
    }
}

resource "aws_network_interface" "NIC1" {
    provider        = aws.west
    subnet_id       = var.subnet_one_west
    private_ips     = ["192.168.20.10"]
    security_groups = [var.instance_SG_west]

    tags = {
        Name = "primary_network_interface_west"
    }
}

resource "aws_instance" "ssm_test_2" {
    provider         = aws.west
    ami              = var.ami_id_west
    instance_type    = var.instance_type
    iam_instance_profile = var.iam_profile

    network_interface {
        network_interface_id = aws_network_interface.NIC2.id
        device_index         = 0
    }
    
    tags = {
        Name = "SSM_Test_Instance_2_west"
    }
}

resource "aws_network_interface" "NIC2" {
    provider        = aws.west
    subnet_id       = var.subnet_two_west
    private_ips     = ["192.168.30.10"]
    security_groups = [var.instance_SG_west]

    tags = {
        Name = "secondary_network_interface_west"
    }
}

resource "aws_instance" "ssm_test_3" {
    provider         = aws.east
    ami              = var.ami_id_east
    instance_type    = var.instance_type
    iam_instance_profile = var.iam_profile

    network_interface {
        network_interface_id = aws_network_interface.NIC3.id
        device_index         = 0
    }

    user_data = <<-EOF
              #!/bin/bash
              # Enhanced SSM Agent Installation Script
              # Log all output to help with debugging
              exec > >(tee /var/log/user-data.log) 2>&1
              echo "Starting user-data script at $(date)"
              
              # Wait for system to stabilize and network to be ready
              echo "Waiting for system stabilization..."
              sleep 60
              
              # Wait for internet connectivity
              echo "Testing internet connectivity..."
              for i in {1..20}; do
                  if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
                      echo "Internet connectivity confirmed after $i attempts"
                      break
                  fi
                  echo "Waiting for internet connectivity... attempt $i/20"
                  sleep 15
              done
              
              # Install SSM Agent
              echo "Starting SSM Agent installation..."
              cd /tmp
              
              # Download with retries
              for i in {1..5}; do
                  if sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm; then
                      echo "SSM Agent installed successfully on attempt $i"
                      break
                  fi
                  echo "Installation failed, retrying... attempt $i/5"
                  sleep 10
              done
              
              # Enable and start the service
              echo "Enabling SSM Agent service..."
              sudo systemctl enable amazon-ssm-agent
              
              echo "Starting SSM Agent service..."
              sudo systemctl start amazon-ssm-agent
              
              # Wait and check status
              sleep 10
              echo "SSM Agent status:"
              sudo systemctl status amazon-ssm-agent

              sleep 30
              sudo dnf install -y httpd

              sudo bash -c 'cat > /var/www/html/index.html << HTML
                <!DOCTYPE html>
                <html>
                <head>
                    <title>East Region Instance</title>
                </head>
                <body>
                    <h1>Hello from East Region!</h1>
                    <p>This is instance $(hostname) in the us-east-2 region.</p>
                    <p>Private IP: $(hostname -I | awk "{print \$1}")</p>
                    <p>Current time: $(date)</p>
                </body>
                </html>
                HTML' 

              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
    
    
    tags = {
        Name = "SSM_Test_Instance_1_east"
    }
}

resource "aws_network_interface" "NIC3" {
    provider        = aws.east
    subnet_id       = var.subnet_one_east
    private_ips     = ["10.0.20.10"]
    security_groups = [var.instance_SG_east]

    tags = {
        Name = "Primary_network_interface_east"
    }
}

resource "aws_instance" "ssm_test_4" {
    provider         = aws.east
    ami              = var.ami_id_east
    instance_type    = var.instance_type
    iam_instance_profile = var.iam_profile

    network_interface {
        network_interface_id = aws_network_interface.NIC4.id
        device_index         = 0
    }

   user_data = <<-EOF
              #!/bin/bash
              # Enhanced SSM Agent Installation Script
              # Log all output to help with debugging
              exec > >(tee /var/log/user-data.log) 2>&1
              echo "Starting user-data script at $(date)"
              
              # Wait for system to stabilize and network to be ready
              echo "Waiting for system stabilization..."
              sleep 60
              
              # Wait for internet connectivity
              echo "Testing internet connectivity..."
              for i in {1..20}; do
                  if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
                      echo "Internet connectivity confirmed after $i attempts"
                      break
                  fi
                  echo "Waiting for internet connectivity... attempt $i/20"
                  sleep 15
              done
              
              # Install SSM Agent
              echo "Starting SSM Agent installation..."
              cd /tmp
              
              # Download with retries
              for i in {1..5}; do
                  if sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm; then
                      echo "SSM Agent installed successfully on attempt $i"
                      break
                  fi
                  echo "Installation failed, retrying... attempt $i/5"
                  sleep 10
              done
              
              # Enable and start the service
              echo "Enabling SSM Agent service..."
              sudo systemctl enable amazon-ssm-agent
              
              echo "Starting SSM Agent service..."
              sudo systemctl start amazon-ssm-agent
              
              # Wait and check status
              sleep 10
              echo "SSM Agent status:"
              sudo systemctl status amazon-ssm-agent
              
              EOF
    
    tags = {
        Name = "SSM_Test_Instance_2_east"
    }
}

resource "aws_network_interface" "NIC4" {
    provider        = aws.east
    subnet_id       = var.subnet_two_east
    private_ips     = ["10.0.30.10"]
    security_groups = [var.instance_SG_east]

    tags = {
        Name = "Secondary_network_interface_east"
    }
}

# Elastic IP for East region instance 1 (ssm_test_3)
resource "aws_eip" "eip_east_1" {
    provider = aws.east
    domain   = "vpc"
    network_interface = aws_network_interface.NIC3.id
    depends_on = [aws_instance.ssm_test_3]
    
    tags = {
        Name = "eip_east_instance_1"
    }
}

# Elastic IP for East region instance 2 (ssm_test_4)  
resource "aws_eip" "eip_east_2" {
    provider = aws.east
    domain   = "vpc"
    network_interface = aws_network_interface.NIC4.id
    depends_on = [aws_instance.ssm_test_4]
    
    tags = {
        Name = "eip_east_instance_2"
    }
}
