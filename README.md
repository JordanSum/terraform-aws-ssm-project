# AWS Systems Manager (SSM) Multi-Region Infrastructure with Terraform

A secure, scalable Infrastructure as Code (IaC) solution demonstrating multi-region AWS architecture using Terraform modules for EC2 instance management via AWS Systems Manager without traditional SSH access. This project showcases enterprise-grade infrastructure deployment across US-West-2 and US-East-2 regions with comprehensive security and networking modules.

## 🏗️ Architecture Overview

This project implements a modern cloud infrastructure pattern that prioritizes security, scalability, and operational excellence by leveraging AWS Systems Manager for secure instance access across multiple AWS regions without exposing SSH ports or requiring bastion hosts. The multi-region design provides high availability, disaster recovery capabilities, and geographic distribution of resources.

### Multi-Region Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                                   MULTI-REGION DEPLOYMENT                                      │
└─────────────────────────────────────────────────────────────────────────────────────────────┘

US-WEST-2 (Primary Region)                          US-EAST-2 (Secondary Region)
┌─────────────────────────────────────────┐         ┌─────────────────────────────────────────┐
│         VPC (192.168.0.0/16)            │         │         VPC (192.168.0.0/16)            │
│  ┌─────────────────┐ ┌─────────────────┐│         │  ┌─────────────────┐ ┌─────────────────┐│
│  │   Subnet-One    │ │   Subnet-Two    ││         │  │   Subnet-One    │ │   Subnet-Two    ││
│  │(192.168.20.0/24)│ │(192.168.30.0/24)││         │  │(192.168.20.0/24)│ │(192.168.30.0/24)││
│  │  AZ: us-west-2a │ │  AZ: us-west-2b ││         │  │  AZ: us-east-2a │ │  AZ: us-east-2b ││
│  │                 │ │                 ││         │  │                 │ │                 ││
│  │  ┌─────────────┐│ │  ┌─────────────┐││         │  │  ┌─────────────┐│ │  ┌─────────────┐││
│  │  │ EC2 Instance││ │  │ EC2 Instance│││         │  │  │ EC2 Instance││ │  │ EC2 Instance│││
│  │  │  (SSM-W1)   ││ │  │  (SSM-W2)   │││         │  │  │  (SSM-E1)   ││ │  │  (SSM-E2)   │││
│  │  └─────────────┘│ │  └─────────────┘││         │  │  └─────────────┘│ │  └─────────────┘││
│  └─────────────────┘ └─────────────────┘│         │  └─────────────────┘ └─────────────────┘│
│                                         │         │                                         │
│  ┌─────────────────────────────────────┐│         │  ┌─────────────────────────────────────┐│
│  │           VPC Endpoints             ││         │  │           VPC Endpoints             ││
│  │ • com.amazonaws.us-west-2.ssm       ││         │  │ • com.amazonaws.us-east-2.ssm       ││
│  │ • com.amazonaws.us-west-2.ssmmsg    ││         │  │ • com.amazonaws.us-east-2.ssmmsg    ││
│  │ • com.amazonaws.us-west-2.ec2msg    ││         │  │ • com.amazonaws.us-east-2.ec2msg    ││
│  └─────────────────────────────────────┘│         │  └─────────────────────────────────────┘│
└─────────────────────────────────────────┘         └─────────────────────────────────────────┘
                    │                                                   │
                    └─────────────────┐         ┌───────────────────────┘
                                      ▼         ▼
                                  ┌─────────────────┐
                                  │   AWS Systems   │
                                  │    Manager      │
                                  │ (Global Service)│
                                  └─────────────────┘
```

## 🚀 Key Features

### Multi-Region Deployment
- **Primary Region**: US-West-2 (Oregon) for primary operations
- **Secondary Region**: US-East-2 (Ohio) for disaster recovery and load distribution
- **Cross-Region Consistency**: Identical infrastructure patterns across regions
- **Geographic Distribution**: Reduced latency for global user base

### Security-First Design
- **Zero SSH Exposure**: No SSH ports open to the internet across all regions
- **Regional VPC Endpoints**: Private communication with AWS services in each region
- **IAM Role-Based Access**: Least privilege access using AWS managed policies
- **Network Segmentation**: Multi-AZ private subnet deployment per region
- **Consistent Security Policies**: Uniform security groups and IAM across regions

### Infrastructure as Code
- **Modular Terraform Architecture**: Reusable, maintainable code structure
- **Multi-Provider Support**: Dual AWS provider configuration for region management
- **State Management**: Consistent infrastructure deployments across regions
- **Version Control**: Trackable infrastructure changes with semantic versioning

### Operational Excellence
- **Session Manager Integration**: Browser-based and CLI access across regions
- **Audit Logging**: All sessions logged via CloudTrail in both regions
- **High Availability**: Multi-AZ deployment within each region
- **Disaster Recovery**: Cross-region redundancy for business continuity
- **Cost Optimization**: No NAT Gateway required for SSM communication

## 📁 Project Structure

```
aws-ssm-project/
├── main.tf                      # Root module with multi-region provider configuration
├── variables.tf                 # Root module variables (includes region-specific vars)
├── terraform.tfvars.example    # Example configuration file for multi-region setup
├── .gitignore                   # Git ignore rules for sensitive files
├── terraform.tfstate*          # Terraform state files (ignored by git)
├── modules/
│   ├── compute/                 # Multi-region EC2 instances and networking
│   │   ├── main.tf              # Instance definitions for both regions
│   │   └── variables.tf         # Module variables including region-specific AMIs
│   ├── networking/              # Multi-region VPC and network infrastructure
│   │   ├── main.tf              # VPCs, subnets, and VPC endpoints for both regions
│   │   ├── variables.tf         # Module variables for network configuration
│   │   └── output.tf            # Network outputs (VPC IDs, subnet IDs, etc.)
│   └── security/                # Multi-region IAM roles and security groups
│       ├── main.tf              # IAM roles, policies, and regional security groups
│       ├── variables.tf         # Module variables for security configuration
│       └── output.tf            # Security outputs (IAM profiles, security group IDs)
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
git clone https://github.com/JordanSum/terraform-aws-ssm-project
cd aws-ssm-project
```

### 2. Configure Variables
```bash
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your actual values
# Update the following required variables for multi-region deployment:

# Project configuration
# - project_name: Your project identifier
# - environment: Environment name (dev, staging, prod)

# Network configuration (same CIDR structure used across both regions)
# - cidr_block: VPC CIDR block (e.g., "192.168.0.0/16")
# - subnet_one_west: West region subnet 1 CIDR (e.g., "192.168.20.0/24")
# - subnet_two_west: West region subnet 2 CIDR (e.g., "192.168.30.0/24")
# - subnet_one_east: East region subnet 1 CIDR (e.g., "192.168.20.0/24")
# - subnet_two_east: East region subnet 2 CIDR (e.g., "192.168.30.0/24")

# EC2 configuration (region-specific AMIs)
# - ami_id_west: Amazon Linux 2 AMI ID for us-west-2
# - ami_id_east: Amazon Linux 2 AMI ID for us-east-2
# - instance_type: EC2 instance type (e.g., "t2.micro")
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

#### Option B: AWS CLI (Multi-Region Access)
```bash
# List available instances across both regions
aws ssm describe-instance-information --region us-west-2
aws ssm describe-instance-information --region us-east-2

# Start session with instance in us-west-2
aws ssm start-session --target i-1234567890abcdef0 --region us-west-2

# Start session with instance in us-east-2
aws ssm start-session --target i-0987654321fedcba0 --region us-east-2
```

## 🏢 Enterprise Benefits

### Security Compliance
- **CIS Controls Alignment**: Implements secure access patterns across regions
- **Zero Trust Architecture**: No implicit trust, verify everything across environments
- **Audit Trail**: Complete session logging for compliance in both regions
- **Disaster Recovery**: Geographic separation for business continuity
- **Regional Compliance**: Ability to meet data residency requirements

### Cost Optimization
- **Reduced Infrastructure**: No bastion hosts or NAT gateways needed in either region
- **Operational Efficiency**: Simplified access management across regions
- **Scalability**: Pay-as-you-grow model with regional flexibility
- **Resource Optimization**: Efficient use of regional AWS services

### DevOps Best Practices
- **Infrastructure as Code**: Repeatable, version-controlled deployments across regions
- **Immutable Infrastructure**: Consistent environment provisioning in both regions
- **Automated Provisioning**: Reduced manual configuration errors
- **Multi-Region Orchestration**: Coordinated deployment using Terraform providers

## 🔧 Configuration Details

### Current Configuration
The project is configured with the following multi-region settings:

#### Network Configuration (Both Regions)
- **VPC CIDR**: 192.168.0.0/16 (consistent across regions)
- **Subnet One**: 192.168.20.0/24 (us-west-2a & us-east-2a)
- **Subnet Two**: 192.168.30.0/24 (us-west-2b & us-east-2b)

#### Compute Configuration
- **Instance Type**: t2.micro (cost-optimized for demo)
- **AMI West**: Amazon Linux 2 (region-specific AMI for us-west-2)
- **AMI East**: Amazon Linux 2 (region-specific AMI for us-east-2)

#### Regional Deployment
- **Primary Region**: us-west-2 (Oregon)
- **Secondary Region**: us-east-2 (Ohio)
- **Availability Zones**: 2 AZs per region for high availability

### Module Architecture
- **Compute Module**: Manages EC2 instances and network interfaces across both regions
- **Networking Module**: Handles VPCs, subnets, and VPC endpoints in us-west-2 and us-east-2
- **Security Module**: Manages IAM roles, policies, and region-specific security groups

### Multi-Region VPC Endpoints
The project creates essential VPC endpoints for SSM functionality in both regions:

#### US-West-2 Endpoints
- **SSM Endpoint**: com.amazonaws.us-west-2.ssm
- **SSM Messages**: com.amazonaws.us-west-2.ssmmessages
- **EC2 Messages**: com.amazonaws.us-west-2.ec2messages

#### US-East-2 Endpoints
- **SSM Endpoint**: com.amazonaws.us-east-2.ssm
- **SSM Messages**: com.amazonaws.us-east-2.ssmmessages
- **EC2 Messages**: com.amazonaws.us-east-2.ec2messages

### Security Groups
- **Instance Security Groups**: Allows HTTPS outbound to VPC endpoints (per region)
- **VPC Endpoint Security Groups**: Allows HTTPS inbound from VPC CIDR (per region)
- **Cross-Region Consistency**: Identical security group rules across both regions

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

### Verify SSM Agent Status (Multi-Region)
```bash
# Check if instances are managed by SSM in us-west-2
aws ssm describe-instance-information --region us-west-2

# Check if instances are managed by SSM in us-east-2
aws ssm describe-instance-information --region us-east-2

# Get instance details with tags
aws ssm describe-instance-information --region us-west-2 --query 'InstanceInformationList[*].{InstanceId:InstanceId,PingStatus:PingStatus,PlatformType:PlatformType}'
aws ssm describe-instance-information --region us-east-2 --query 'InstanceInformationList[*].{InstanceId:InstanceId,PingStatus:PingStatus,PlatformType:PlatformType}'
```

### Session Manager Logs
Session Manager logs are available in both regions:
- **CloudTrail**: API calls and session starts (per region)
- **CloudWatch Logs**: Session data (if configured, per region)

### Common Issues
1. **Instance not appearing in SSM**: Check IAM role attachment and VPC endpoint connectivity in the specific region
2. **Connection timeout**: Verify security group rules and VPC endpoint configuration for the target region
3. **Cross-region access issues**: Ensure you're connecting to the correct region where the instance is deployed
4. **Permission denied**: Ensure proper IAM policies are attached and region-specific permissions are configured

## 🧹 Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

**Important**: This will permanently delete all resources created by this project in BOTH regions. Make sure to:
- Back up any important data from the EC2 instances in both us-west-2 and us-east-2
- Confirm you want to delete all resources across both regions
- Review the destruction plan before confirming (will show resources in both regions)

## ⚙️ Development Notes

### Git Configuration
This project includes a comprehensive `.gitignore` file that:
- Excludes Terraform state files from version control
- Protects sensitive configuration files (`terraform.tfvars`)
- Includes the example configuration file (`terraform.tfvars.example`)
- Ignores common development files and directories

### Best Practices Implemented
- **Modular architecture**: Separated into compute, networking, and security modules with multi-region support
- **Variable management**: Centralized variable definitions with region-specific configurations
- **Security**: No hardcoded sensitive values in code, region-aware security policies
- **Documentation**: Comprehensive example configuration for multi-region deployment
- **Provider Management**: Dual AWS provider configuration for seamless multi-region orchestration

## 🎯 Resume Highlights

This project demonstrates:

### Technical Skills
- **Multi-Region Cloud Architecture**: Distributed AWS infrastructure design across multiple regions
- **Infrastructure as Code**: Terraform best practices with advanced multi-provider configuration
- **Security Engineering**: Zero-trust networking and IAM implementation across regions
- **DevOps Practices**: Automated provisioning and configuration management at scale
- **Disaster Recovery**: Cross-region redundancy and business continuity planning

### Business Value
- **Cost Reduction**: Eliminated traditional bastion host infrastructure across regions
- **Security Enhancement**: Removed SSH attack vectors with comprehensive regional coverage
- **Operational Efficiency**: Simplified access management across geographically distributed infrastructure
- **Scalability**: Foundation for enterprise-grade, globally distributed infrastructure
- **Business Continuity**: Regional redundancy for disaster recovery and high availability

### AWS Services Expertise
- **Core Services**: EC2, VPC, IAM, Systems Manager across multiple regions
- **Networking**: VPC Endpoints, Security Groups, Cross-region networking, CloudTrail
- **Advanced Patterns**: Multi-region architecture, cost optimization, and security best practices
- **Provider Management**: Advanced Terraform multi-provider configuration

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Contact

**Jordan** - [LinkedIn](https://linkedin.com/in/sumnertech) - [Resume Website](https://sumnertech.net)

Project Link: [https://github.com/JordanSum/terraform-aws-ssm-project](https://github.com/JordanSum/terraform-aws-ssm-project)

---

⭐ **Star this repository if it helped you learn AWS infrastructure and Terraform!**
