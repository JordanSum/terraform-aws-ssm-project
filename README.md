# AWS Systems Manager (SSM) Infrastructure with Terraform

A secure, scalable Infrastructure as Code (IaC) solution demonstrating enterprise-grade AWS architecture using Terraform modules for EC2 instance management via AWS Systems Manager without traditional SSH access.

## 🏗️ Architecture Overview

This project implements a modern cloud infrastructure pattern that prioritizes security, scalability, and operational excellence by leveraging AWS Systems Manager for secure instance access without exposing SSH ports or requiring bastion hosts.

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        VPC (192.168.0.0/16)                     │
│  ┌─────────────────┐                    ┌─────────────────┐     │
│  │   Subnet-One    │                    │   Subnet-Two    │     │
│  │(192.168.20.0/24)│                    │(192.168.30.0/24)│     │
│  │  AZ: us-west-2a │                    │  AZ: us-west-2b │     │
│  │                 │                    │                 │     │
│  │  ┌─────────────┐│                    │  ┌─────────────┐│     │
│  │  │ EC2 Instance││                    │  │ EC2 Instance││     │
│  │  │  (SSM-1)    ││                    │  │  (SSM-2)    ││     │
│  │  └─────────────┘│                    │  └─────────────┘│     │
│  └─────────────────┘                    └─────────────────┘     │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                VPC Endpoints                            │    │
│  │  • com.amazonaws.us-west-2.ssm                          │    │
│  │  • com.amazonaws.us-west-2.ssmmessages                  │    │
│  │  • com.amazonaws.us-west-2.ec2messages                  │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │   AWS Systems   │
                    │    Manager      │
                    └─────────────────┘
```

## 🚀 Key Features

### Security-First Design
- **Zero SSH Exposure**: No SSH ports open to the internet
- **VPC Endpoints**: Private communication with AWS services
- **IAM Role-Based Access**: Least privilege access using AWS managed policies
- **Network Segmentation**: Multi-AZ private subnet deployment

### Infrastructure as Code
- **Modular Terraform Architecture**: Reusable, maintainable code structure
- **State Management**: Consistent infrastructure deployments
- **Version Control**: Trackable infrastructure changes

### Operational Excellence
- **Session Manager Integration**: Browser-based and CLI access
- **Audit Logging**: All sessions logged via CloudTrail
- **High Availability**: Multi-AZ deployment for resilience
- **Cost Optimization**: No NAT Gateway required for SSM communication

## 📁 Project Structure

```
aws-ssm-project/
├── main.tf                      # Root module orchestration
├── variables.tf                 # Root module variables
├── terraform.tfvars.example    # Example configuration file
├── .gitignore                   # Git ignore rules for sensitive files
├── terraform.tfstate*          # Terraform state files (ignored by git)
├── modules/
│   ├── compute/                 # EC2 instances and networking
│   │   ├── main.tf              # Instance and network interface definitions
│   │   └── variables.tf         # Module variables
│   ├── networking/              # VPC and network infrastructure
│   │   ├── main.tf              # VPC, subnets, and VPC endpoints
│   │   └── variables.tf         # Module variables
│   │   └── output.tf            # Module outputs
│   └── security/                # IAM roles and security groups
│       ├── main.tf              # IAM roles, policies, and security groups
│       ├── variables.tf         # Module variables
│       └── output.tf            # Module outputs
└── README.md                    # Project documentation
```

## 🛠️ Technologies Used

- **Terraform**: Infrastructure as Code
- **AWS EC2**: Compute instances
- **AWS VPC**: Network isolation
- **AWS Systems Manager**: Secure instance access
- **AWS IAM**: Identity and access management
- **AWS VPC Endpoints**: Private service communication

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS Account with permissions for EC2, VPC, IAM, and SSM services

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd aws-ssm-project
```

### 2. Configure Variables
```bash
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Create terraform.tfvars file
# Edit terraform.tfvars with your actual values
# Update the following required variables:
# - project_name: Your project identifier
# - cidr_block: VPC CIDR block (e.g., "10.0.0.0/16")
# - subnet_one: First subnet CIDR (e.g., "10.0.1.0/24")
# - subnet_two: Second subnet CIDR (e.g., "10.0.2.0/24")
# - ami_id: Amazon Linux 2 AMI ID for your region
# - instance_type: EC2 instance type (e.g., "t2.micro")
# - environment: Environment name (e.g., "dev")
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Review the Plan
```bash
terraform plan
```

### 5. Deploy Infrastructure
```bash
terraform apply
```

### 6. Access Your Instances

#### Option A: AWS Console
1. Navigate to **EC2 Console** → **Instances**
2. Select your instance → **Connect** → **Session Manager**
3. Click **Connect**

#### Option B: AWS CLI
```bash
# List available instances
aws ssm describe-instance-information

# Start session with instance
aws ssm start-session --target i-1234567890abcdef0
```

## 🏢 Enterprise Benefits

### Security Compliance
- **CIS Controls Alignment**: Implements secure access patterns
- **Zero Trust Architecture**: No implicit trust, verify everything
- **Audit Trail**: Complete session logging for compliance

### Cost Optimization
- **Reduced Infrastructure**: No bastion hosts or NAT gateways needed
- **Operational Efficiency**: Simplified access management
- **Scalability**: Pay-as-you-grow model

### DevOps Best Practices
- **Infrastructure as Code**: Repeatable, version-controlled deployments
- **Immutable Infrastructure**: Consistent environment provisioning
- **Automated Provisioning**: Reduced manual configuration errors

## 🔧 Configuration Details

### Current Configuration
The project is configured with the following default settings:
- **VPC CIDR**: 192.168.0.0/16
- **Subnet One**: 192.168.20.0/24 (us-west-2a)
- **Subnet Two**: 192.168.30.0/24 (us-west-2b)
- **Instance Type**: t2.micro
- **AMI**: Amazon Linux 2 (ami-054b7fc3c333ac6d2)

### Module Architecture
- **Compute Module**: Manages EC2 instances and network interfaces
- **Networking Module**: Handles VPC, subnets, and VPC endpoints
- **Security Module**: Manages IAM roles, policies, and security groups

### VPC Endpoints
The project creates essential VPC endpoints for SSM functionality:
- **SSM Endpoint**: Core Systems Manager service
- **SSM Messages**: Session Manager communication
- **EC2 Messages**: Instance-to-service messaging

### Security Groups
- **Instance Security Group**: Allows HTTPS outbound to VPC endpoints
- **VPC Endpoint Security Group**: Allows HTTPS inbound from VPC CIDR

### IAM Configuration
Uses AWS managed policy `AmazonSSMManagedInstanceCore` providing:
- SSM Agent registration and communication
- CloudWatch logs and metrics
- S3 access for session recordings (if configured)

### File Security
- **terraform.tfvars**: Contains sensitive configuration (ignored by git)
- **terraform.tfvars.example**: Template file for configuration
- **.gitignore**: Protects sensitive files from being committed

## 📈 Monitoring and Troubleshooting

### Verify SSM Agent Status
```bash
# Check if instances are managed by SSM
aws ssm describe-instance-information
```

### Session Manager Logs
Session Manager logs are available in:
- **CloudTrail**: API calls and session starts
- **CloudWatch Logs**: Session data (if configured)

### Common Issues
1. **Instance not appearing in SSM**: Check IAM role attachment and VPC endpoint connectivity
2. **Connection timeout**: Verify security group rules and VPC endpoint configuration
3. **Permission denied**: Ensure proper IAM policies are attached

## 🧹 Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

**Important**: This will permanently delete all resources created by this project. Make sure to:
- Back up any important data from the EC2 instances
- Confirm you want to delete all resources
- Review the destruction plan before confirming

## ⚙️ Development Notes

### Git Configuration
This project includes a comprehensive `.gitignore` file that:
- Excludes Terraform state files from version control
- Protects sensitive configuration files (`terraform.tfvars`)
- Includes the example configuration file (`terraform.tfvars.example`)
- Ignores common development files and directories

### Best Practices Implemented
- **Modular architecture**: Separated into compute, networking, and security modules
- **Variable management**: Centralized variable definitions
- **Security**: No hardcoded sensitive values in code
- **Documentation**: Comprehensive example configuration

## 🎯 Resume Highlights

This project demonstrates:

### Technical Skills
- **Cloud Architecture**: Multi-tier AWS infrastructure design
- **Infrastructure as Code**: Terraform best practices and modular design
- **Security Engineering**: Zero-trust networking and IAM implementation
- **DevOps Practices**: Automated provisioning and configuration management

### Business Value
- **Cost Reduction**: Eliminated traditional bastion host infrastructure
- **Security Enhancement**: Removed SSH attack vectors
- **Operational Efficiency**: Simplified access management and audit compliance
- **Scalability**: Foundation for enterprise-grade infrastructure

### AWS Services Expertise
- EC2, VPC, IAM, Systems Manager
- VPC Endpoints, Security Groups, CloudTrail
- Cost optimization and security best practices

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Contact

**Jordan** - [Your LinkedIn](https://linkedin.com/in/yourprofile) - your.email@example.com

Project Link: [https://github.com/JordanSum/terraform-aws-ssm-project](https://github.com/JordanSum/terraform-aws-ssm-project)

---

⭐ **Star this repository if it helped you learn AWS infrastructure and Terraform!**
