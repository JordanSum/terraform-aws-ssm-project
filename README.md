# AWS Systems Manager (SSM) Multi-Region Infrastructure with Terraform (Backups + Monitoring)

A secure, scalable Infrastructure as Code (IaC) solution demonstrating multi-region AWS architecture using Terraform modules for EC2 instance management via AWS Systems Manager without traditional SSH access. This project showcases enterprise-grade infrastructure deployment across US-West-2 and US-East-2 regions with comprehensive security, networking, compute, automated backups with cross-region copy (to us-west-1), and monitoring (CloudWatch dashboards, alarms, and budgets). East region exposes simple Apache web servers for testing; West region remains private (SSM-only).

## 🏗️ Architecture Overview

This project implements a modern cloud infrastructure pattern that prioritizes security, scalability, and operational excellence by leveraging AWS Systems Manager for secure instance access across multiple AWS regions without exposing SSH ports or requiring bastion hosts. The multi-region design provides high availability, disaster recovery capabilities, and geographic distribution of resources. Automated backups run hourly per source region and are copied to a consolidation vault in us-west-1 for DR.

### Multi-Region Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                                   MULTI-REGION DEPLOYMENT                                   │
└─────────────────────────────────────────────────────────────────────────────────────────────┘

US-WEST-2 (Primary Region)                          US-EAST-2 (Secondary Region)
┌─────────────────────────────────────────┐         ┌─────────────────────────────────────────┐
│         VPC (192.168.0.0/16)            │         │         VPC (10.0.0.0/16)               │
│  ┌─────────────────┐ ┌─────────────────┐│         │  ┌─────────────────┐ ┌─────────────────┐│
│  │   Subnet-One    │ │   Subnet-Two    ││         │  │   Subnet-One    │ │   Subnet-Two    ││
│  │(192.168.20.0/24)│ │(192.168.30.0/24)││         │  │(10.0.20.0/24)   │ │(10.0.30.0/24)   ││
│  │  AZ: us-west-2a │ │  AZ: us-west-2b ││         │  │  AZ: us-east-2a │ │  AZ: us-east-2b ││
│  │                 │ │                 ││         │  │                 │ │                 ││
│  │  ┌─────────────┐│ │  ┌─────────────┐││         │  │  ┌─────────────┐│ │  ┌─────────────┐││
│  │  │ EC2 Instance││ │  │ EC2 Instance│││         │  │  │ EC2 Instance││ │  │ EC2 Instance│││
│  │  │  (SSM-W1)   ││ │  │  (SSM-W2)   │││         │  │  │(SSM-E1)+EIP ││ │  │(SSM-E2)+EIP │││
│  │  │Private Only ││ │  │Private Only │││         │  │  │+Apache HTTP ││ │  │+Apache HTTP │││
│  │  └─────────────┘│ │  └─────────────┘││         │  │  └─────────────┘│ │  └─────────────┘││
│  └─────────────────┘ └─────────────────┘│         │  └─────────────────┘ └─────────────────┘│
│                                         │         │                                         │
│  ┌─────────────────────────────────────┐│   ◄──── │  ┌─────────────────────────────────────┐│
│  │           VPC Endpoints             ││ PEERING │  │           VPC Endpoints             ││
│  │ • com.amazonaws.us-west-2.ssm       ││ ──────► │  │ • com.amazonaws.us-east-2.ssm       ││
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

                              ┌────────────────────────────┐
                              │       AWS Backup (per Rgn) │
                              │  Plan + Vault (west/east)  │
                              └─────────────┬──────────────┘
                                            │ copy_action
                                            ▼
                                 ┌─────────────────────────┐
                                 │  DR Vault (us-west-1)   │
                                 │ ec2_backup_vault_west   │
                                 │        _copy            │
                                 └─────────────────────────┘
```

## 🚀 Key Features

### Multi-Region Deployment
- **Primary Region**: US-West-2 (Oregon) with private instances
- **Secondary Region**: US-East-2 (Ohio) with public-facing instances
- **DR Copy Region**: US-West-1 (N. California) consolidation vault for cross-region backup copies
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
- **Multi-Provider Support**: Multiple AWS provider aliases (west1, west2, east) for region management
- **State Management**: Consistent infrastructure deployments across regions
- **Version Control**: Trackable infrastructure changes with semantic versioning

### Operational Excellence
- **Session Manager Integration**: Browser-based and CLI access across regions
- **Audit Logging**: Session start/stop via CloudTrail
- **High Availability**: Multi-AZ deployment within each region
- **Disaster Recovery**: Cross-region redundancy for business continuity
- **Cost Optimization**: No NAT Gateway required for SSM communication

### Backup & Monitoring
- **Automated Backups**: Hourly EC2 backups in us-west-2 and us-east-2
- **Cross-Region Copy**: Backup copies to us-west-1 vault with 30-day retention
- **CloudWatch Dashboards**: Per-region dashboards with CPU/network widgets
- **Alarms**: CPU utilization alarms for all instances
- **Budgets**: Monthly cost budget with email alerts

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
│   │   ├── variables.tf         # Module variables including region-specific AMIs
│   │   └── output.tf            # Compute outputs (instance IPs, etc.)
│   ├── networking/              # Multi-region VPC and network infrastructure
│   │   ├── main.tf              # VPCs, subnets, and VPC endpoints for both regions
│   │   ├── variables.tf         # Module variables for network configuration
│   │   └── output.tf            # Network outputs (VPC IDs, subnet IDs, etc.)
│   ├── security/                # Multi-region IAM roles and security groups
│   │   ├── main.tf              # IAM roles, policies, and regional security groups
│   │   ├── variables.tf         # Module variables for security configuration
│   │   └── output.tf            # Security outputs (IAM profiles, security group IDs)
│   └── peering/                 # Cross-region VPC peering connectivity
│       ├── main.tf              # VPC peering connection and route configuration
│       ├── variables.tf         # Module variables for peering setup
│       └── output.tf            # Peering outputs (connection IDs, status)
│   ├── backup/                  # AWS Backup plans, vaults, selections, cross-region copy
│   │   ├── main.tf              # Plans with copy_action to us-west-1, vault policies
│   │   ├── variables.tf         # Backup inputs (instance IDs, role ARN)
│   │   └── output.tf            # Backup-related outputs
│   └── monitoring/              # Dashboards, alarms, budgets, log groups/policies
│       ├── main.tf              # CloudWatch dashboards/alarms/budgets, SSM log groups
│       ├── variables.tf         # Monitoring inputs (instance IDs, project name)
│       └── output.tf            # Dashboard names/URLs, alarm names, log group names
└── README.md                    # Project documentation
```

## 🛠️ Technologies Used

- **Terraform**: Infrastructure as Code
- **AWS EC2**: Compute instances
- **AWS VPC**: Network isolation
- **AWS Systems Manager**: Secure instance access
- **AWS Backup**: Automated backups and cross‑region copy
- **Amazon CloudWatch**: Dashboards, alarms, log groups, resource policies
- **AWS Budgets**: Cost monitoring and email alerts
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
project_name       = "ssm_project_terraform"
environment        = "dev"

# Network configuration (different CIDR blocks for each region)
cidr_block_west    = "192.168.0.0/16"    # West region VPC
cidr_block_east    = "10.0.0.0/16"       # East region VPC
subnet_one_west    = "192.168.20.0/24"   # West AZ-a subnet
subnet_two_west    = "192.168.30.0/24"   # West AZ-b subnet
subnet_one_east    = "10.0.20.0/24"      # East AZ-a subnet
subnet_two_east    = "10.0.30.0/24"      # East AZ-b subnet

# EC2 configuration (region-specific AMIs for Amazon Linux 2023)
ami_id_west        = "ami-054b7fc3c333ac6d2"  # Amazon Linux 2023 us-west-2
ami_id_east        = "ami-068d5d5ed1eeea07c"  # Amazon Linux 2023 us-east-2
instance_type      = "t2.micro"               # Free tier eligible
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
aws ssm start-session --target i-<instance-id> --region us-west-2

# Start session with instance in us-east-2
aws ssm start-session --target i-<instance-id> --region us-east-2
```

### 7. Install Apache Web Server (Recommended Approach)

For reliability, it's recommended to install Apache manually via SSM Session Manager after confirming SSM Agent is working, for this project we have added it the the user data in compute main.tf:

#### Connect to East Region Instances
```bash
# Connect via SSM Session Manager to either east region instance
aws ssm start-session --target i-<instance-id> --region us-east-2
```

#### Install and Configure Apache
```bash
# Install Apache HTTP server
sudo dnf install -y httpd

# Create a custom HTML page
sudo tee /var/www/html/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>East Region Instance</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { background-color: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .status { color: #28a745; font-weight: bold; }
        .info { background-color: #e9ecef; padding: 15px; border-radius: 4px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌐 Hello from East Region!</h1>
        <div class="info">
            <p><strong>Instance:</strong> \$(hostname)</p>
            <p><strong>Private IP:</strong> \$(hostname -I | awk '{print \$1}')</p>
            <p><strong>Region:</strong> us-east-2 (Ohio)</p>
            <p><strong>Time:</strong> \$(date)</p>
        </div>
        <p class="status">✅ SSM Agent: RUNNING</p>
        <p class="status">✅ Apache HTTP Server: ACTIVE</p>
        <hr>
        <p><em>Deployed via AWS Systems Manager - No SSH required!</em></p>
    </div>
</body>
</html>
EOF

# Enable and start Apache service
sudo systemctl enable httpd
sudo systemctl start httpd

# Verify Apache is running
sudo systemctl status httpd
```

#### Access the Web Server
Since the east region instances have Elastic IPs, you can access the Apache server externally:
```bash
# Get the public IP of your instance
aws ec2 describe-instances --region us-east-2 --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,Tags[?Key==`Name`].Value]' --output table

# Access via browser or curl
curl http://<ELASTIC-IP-ADDRESS>
```

### 8. Test Cross-Region Connectivity (VPC Peering)

The VPC peering connection allows instances in different regions to communicate privately. Here's how to test it:

#### From West Region to East Region
```bash
# Connect to a west region instance via SSM
aws ssm start-session --target i-<west-instance-id> --region us-west-2

# Test connectivity to east region instances (private IPs)
ping 10.0.20.10  # East region instance 1
ping 10.0.30.10  # East region instance 2

# Test HTTP connectivity to Apache servers in east region
curl http://10.0.20.10  # Access Apache on east instance 1
curl http://10.0.30.10  # Access Apache on east instance 2
```

#### From East Region to West Region
```bash
# Connect to an east region instance via SSM
aws ssm start-session --target i-<east-instance-id> --region us-east-2

# Test connectivity to west region instances (private IPs)
ping 192.168.20.10  # West region instance 1
ping 192.168.30.10  # West region instance 2
```

#### Verify Peering Connection Status
```bash
# Check peering connection status
aws ec2 describe-vpc-peering-connections --region us-west-2 --query 'VpcPeeringConnections[*].{Status:Status.Code,VpcId:RequesterVpcInfo.VpcId,PeerVpcId:AccepterVpcInfo.VpcId}'

# Check route tables include peering routes
aws ec2 describe-route-tables --region us-west-2 --query 'RouteTables[*].Routes[?VpcPeeringConnectionId!=null]'
aws ec2 describe-route-tables --region us-east-2 --query 'RouteTables[*].Routes[?VpcPeeringConnectionId!=null]'
```

## 🔄 Backups and Disaster Recovery

This project configures automated EC2 backups with cross‑region copy:

- Source Regions: us-west-2 and us-east-2
- Schedule: Hourly (cron(0 * * * ? *))
- Source Retention: 14 days
- Cross-Region Copy: Destination vault in us-west-1
- Copy Retention: 30 days in destination vault
- Implementation: `copy_action` within backup plan rules (no deprecated/unsupported resources)

Vaults
- us-west-2: `ec2_backup_vault_west1` (source)
- us-east-2: `ec2_backup_vault_east` (source)
- us-west-1: `ec2_backup_vault_west_copy` (destination/consolidation)

Verify backups and copies
```bash
# Source backups
aws backup list-backup-jobs --region us-west-2 --max-results 20
aws backup list-backup-jobs --region us-east-2 --max-results 20

# Cross-region copy jobs
aws backup list-copy-jobs --region us-west-2 --max-results 20
aws backup list-copy-jobs --region us-east-2 --max-results 20

# Destination recovery points (DR vault in us-west-1)
aws backup list-recovery-points-by-backup-vault \
    --backup-vault-name ec2_backup_vault_west_copy \
    --region us-west-1
```

Notes
- Copy jobs can take 10–30+ minutes depending on AMI size; check again if the DR vault is briefly empty.
- IAM role `backup_selection_role` is attached to selections and used by AWS Backup for jobs and copies.
- Instance selections include both instances per region via their ARNs.

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

#### Network Configuration
- **West Region VPC CIDR**: 192.168.0.0/16 (us-west-2)
- **East Region VPC CIDR**: 10.0.0.0/16 (us-east-2)
- **West Subnet One**: 192.168.20.0/24 (us-west-2a)
- **West Subnet Two**: 192.168.30.0/24 (us-west-2b)
- **East Subnet One**: 10.0.20.0/24 (us-east-2a)
- **East Subnet Two**: 10.0.30.0/24 (us-east-2b)

#### Compute Configuration
- **Instance Type**: t2.micro (cost-optimized for demo)
- **AMI West**: ami-054b7fc3c333ac6d2 (Amazon Linux 2023 for us-west-2)
- **AMI East**: ami-068d5d5ed1eeea07c (Amazon Linux 2023 for us-east-2)
- **East Region Features**: Elastic IPs and Apache HTTP servers
- **West Region**: Private instances (SSM access only)

#### Regional Deployment Features
- **Primary Region**: us-west-2 (Oregon) - Private instances for internal workloads
- **Secondary Region**: us-east-2 (Ohio) - Public-facing instances with Elastic IPs
- **Availability Zones**: 2 AZs per region for high availability
- **Cross-Region Connectivity**: VPC peering for secure inter-region communication

### Module Architecture
- **Compute Module**: Manages EC2 instances and network interfaces across both regions
- **Networking Module**: Handles VPCs, subnets, and VPC endpoints in us-west-2 and us-east-2
- **Security Module**: Manages IAM roles, policies, and region-specific security groups
- **Peering Module**: Establishes cross-region VPC peering for secure inter-region communication

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

### Cross-Region VPC Peering
The project implements VPC peering to enable secure communication between regions:

#### Peering Configuration
- **Connection Type**: Cross-region VPC peering between us-west-2 and us-east-2
- **Initiation**: Peering connection initiated from us-west-2 (primary region)
- **Acceptance**: Automatically accepted in us-east-2 region
- **Route Tables**: Bidirectional routing configured for both regions

#### Network Routes
- **West to East**: Routes traffic from 192.168.0.0/16 to 10.0.0.0/16 via peering connection
- **East to West**: Routes traffic from 10.0.0.0/16 to 192.168.0.0/16 via peering connection
- **Route Scope**: Applied to all route tables in both regions for comprehensive connectivity

#### Use Cases
- **Cross-Region Communication**: Instances in different regions can communicate privately
- **Disaster Recovery**: Enables data replication and failover scenarios
- **Load Distribution**: Allows workload distribution across geographic regions
- **Centralized Services**: West region instances can access services in east region (and vice versa)

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

### SSM Agent Installation Troubleshooting

#### Issue: SSM Agent Not Installing via User-Data
**Problem**: Complex user-data scripts with nested heredoc configurations can fail during instance boot.

**Solution**: Use the two-step approach implemented in this project:
1. **Deploy infrastructure** with minimal user-data (basic SSM Agent installation)
2. **Manually install applications** via SSM Session Manager after confirming connectivity

#### Recommended SSM Agent Installation Process
```bash
# Step 1: Check if SSM Agent is pre-installed (Amazon Linux 2023 usually has it)
sudo systemctl status amazon-ssm-agent

# Step 2: If not installed, install via package manager
cd /tmp
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

# Step 3: Enable and start the service
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# Step 4: Verify it's running
sudo systemctl status amazon-ssm-agent
```

#### Check User-Data Logs
If you're troubleshooting user-data script issues:
```bash
# View user-data execution log
sudo cat /var/log/user-data.log

# Check cloud-init logs
sudo cat /var/log/cloud-init.log
sudo cat /var/log/cloud-init-output.log
```

### Session Manager Logs
Session Manager logs are available in both regions:
- **CloudTrail**: API calls and session starts (per region)

### Common Issues and Solutions

#### 1. Instance Not Appearing in SSM
**Symptoms**: Instance doesn't show up in Session Manager
**Solutions**:
- Check IAM role attachment: `aws ec2 describe-instances --instance-ids i-xxxxx --query 'Reservations[*].Instances[*].IamInstanceProfile'`
- Verify VPC endpoint connectivity in the specific region
- Ensure SSM Agent is running: `sudo systemctl status amazon-ssm-agent`
- Check security group allows HTTPS (443) outbound in VPC not instance

#### 2. Connection Timeout
**Symptoms**: Session Manager connection fails or times out
**Solutions**:
- Verify security group rules allow HTTPS to VPC endpoints
- Check VPC endpoint configuration for the target region
- Ensure instance has proper IAM permissions
- Verify network connectivity: `ping vpc-endpoint-ssm`

#### 3. Cross-Region Access Issues
**Symptoms**: Can't connect to instances in specific regions
**Solutions**:
- Ensure you're connecting to the correct region where the instance is deployed
- Check AWS CLI profile region configuration: `aws configure get region`
- Verify region-specific VPC endpoints are properly configured

#### 4. User-Data Script Failures
**Symptoms**: Applications not installing during boot
**Solutions**:
- Use the recommended two-step deployment approach
- Check user-data logs: `sudo cat /var/log/user-data.log`
- Install applications manually via SSM Session Manager for better reliability
- Avoid complex nested heredoc structures in user-data

#### 5. Apache Not Accessible Externally
**Symptoms**: Can access Apache locally but not via Elastic IP
**Solutions**:
- Check security group allows HTTP (80) inbound from 0.0.0.0/0
- Verify Elastic IP is properly attached: `aws ec2 describe-addresses --region us-east-2`
- Ensure Apache is listening on all interfaces: `sudo netstat -tlnp | grep :80`
- Test local connectivity first: `curl http://localhost`

### Best Practices for Production

#### Deployment Strategy
1. **Infrastructure First**: Deploy Terraform infrastructure with basic SSM connectivity
2. **Verify Connectivity**: Confirm all instances appear in Session Manager
3. **Application Installation**: Use SSM Session Manager for reliable application deployment
4. **Testing**: Verify all services before considering deployment complete

#### Monitoring Recommendations
- Enable CloudWatch Logs for Session Manager sessions
- Set up CloudWatch alarms for instance health
- Use Systems Manager Patch Manager for OS updates
- Implement AWS Config for compliance monitoring

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
- **Multi-Region Cloud Architecture**: Distributed AWS infrastructure design across us-west-2 and us-east-2
- **Infrastructure as Code**: Terraform best practices with advanced multi-provider configuration
- **Security Engineering**: Zero-trust networking and IAM implementation across regions
- **DevOps Practices**: Automated provisioning and reliable deployment strategies
- **Problem-Solving**: Implemented robust solutions for SSM Agent installation challenges
- **Disaster Recovery**: Cross-region redundancy with VPC peering for business continuity

### Real-World Problem Solving
- **SSM Agent Reliability**: Developed a two-phase deployment strategy after encountering user-data script limitations
- **Configuration Management**: Implemented manual application deployment via SSM for better reliability
- **Network Architecture**: Designed separate CIDR blocks for true multi-region isolation
- **Troubleshooting**: Created comprehensive debugging procedures for common SSM connectivity issues

### Business Value
- **Cost Reduction**: Eliminated traditional bastion host infrastructure across regions
- **Security Enhancement**: Removed SSH attack vectors with comprehensive regional coverage  
- **Operational Efficiency**: Simplified access management across geographically distributed infrastructure
- **Reliability**: Implemented proven deployment patterns that work consistently in production
- **Scalability**: Foundation for enterprise-grade, globally distributed infrastructure
- **Business Continuity**: Regional redundancy for disaster recovery and high availability

### AWS Services Expertise
- **Core Services**: EC2, VPC, IAM, Systems Manager across multiple regions
- **Networking**: VPC Endpoints, Security Groups, Elastic IPs, Cross-region VPC peering
- **Advanced Patterns**: Multi-region architecture, VPC peering, cost optimization, and security best practices
- **Data Protection**: Automated backups with cross‑region copy and retention policies
- **Provider Management**: Advanced Terraform multi-provider configuration with regional resource management
- **Cross-Region Connectivity**: Implemented secure private communication between geographically distributed VPCs

### Production-Ready Features
- **Elastic IPs**: Public accessibility for web services in the east region
- **Apache HTTP Servers**: Demonstrated web application deployment and management
- **Monitoring**: Comprehensive logging and troubleshooting procedures
- **Backups/DR**: Hourly backups and cross‑region copy with lifecycle management
- **Documentation**: Detailed operational procedures for maintenance and troubleshooting
- **Security Groups**: Properly configured for both private (west) and public (east) access patterns

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

---

⭐ **Star this repository if it helped you learn AWS infrastructure and Terraform!**
