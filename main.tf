terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.4.0"
    }
  }
}

#Configure AWS Provider

provider "aws" {
  region = "us-west-2"
  alias  = "west2"
}

provider "aws" {
  region = "us-west-1"
  alias  = "west1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "east"
}

module "compute" {
  source           = "./modules/compute"
  ami_id_west      = var.ami_id_west
  ami_id_east      = var.ami_id_east
  instance_type    = var.instance_type
  subnet_one_west  = module.networking.subnet_one_west
  subnet_two_west  = module.networking.subnet_two_west
  subnet_one_east  = module.networking.subnet_one_east
  subnet_two_east  = module.networking.subnet_two_east
  iam_profile      = module.security.iam_profile
  instance_SG_west = module.security.instance_SG_west
  instance_SG_east = module.security.instance_SG_east

  providers = {
    aws.west2 = aws.west2
    aws.east = aws.east
  }
}

module "networking" {
  source          = "./modules/networking"
  cidr_block_west = var.cidr_block_west
  cidr_block_east = var.cidr_block_east
  subnet_one_west = var.subnet_one_west
  subnet_two_west = var.subnet_two_west
  subnet_one_east = var.subnet_one_east
  subnet_two_east = var.subnet_two_east
  project_name    = var.project_name

  providers = {
    aws.west2 = aws.west2
    aws.east = aws.east
  }
}

module "security" {
  source          = "./modules/security"
  vpc_id_west     = module.networking.vpc_id_west
  vpc_id_east     = module.networking.vpc_id_east
  cidr_block_west = var.cidr_block_west
  cidr_block_east = var.cidr_block_east
  subnet_one_west = module.networking.subnet_one_west
  subnet_two_west = module.networking.subnet_two_west
  subnet_one_east = module.networking.subnet_one_east
  subnet_two_east = module.networking.subnet_two_east

  providers = {
    aws.west2 = aws.west2
    aws.east = aws.east
  }
}

module "peering" {
  source = "./modules/peering"

  vpc_id_west          = module.networking.vpc_id_west
  vpc_id_east          = module.networking.vpc_id_east
  cidr_block_west      = var.cidr_block_west
  cidr_block_east      = var.cidr_block_east
  route_table_ids_west = module.networking.route_table_ids_west
  route_table_ids_east = module.networking.route_table_ids_east
  project_name         = var.project_name

  providers = {
    aws.west2 = aws.west2
    aws.east = aws.east
  }
}

# CloudWatch monitoring module giving the user dashboards for both regions, alarms for instance health, ssm session logging, and cost monitoring alerts.
module "monitoring" {
  source = "./modules/monitoring"

  # CloudWatch Dashboards for both regions
  # CloudWatch Alarms for instance health
  # Cost monitoring and alerts

  # Project configuration
  project_name = var.project_name

  # Instance IDs from compute module
  west_instance_1_id = module.compute.west_instance_1_id
  west_instance_2_id = module.compute.west_instance_2_id
  east_instance_1_id = module.compute.east_instance_1_id
  east_instance_2_id = module.compute.east_instance_2_id

  providers = {
    aws.west2 = aws.west2
    aws.east = aws.east
  }

  depends_on = [module.compute]
}

# Backup module for EC2, including cross-region replication, and automated backup policies.
module "backup" {
  source = "./modules/backup"

  project_name = var.project_name
  backup_iam_role_arn = module.security.backup_iam_role_arn
  west_instance_1_id = module.compute.west_instance_1_id
  west_instance_2_id = module.compute.west_instance_2_id
  east_instance_1_id = module.compute.east_instance_1_id
  east_instance_2_id = module.compute.east_instance_2_id

  providers = {
    aws.west1 = aws.west1
    aws.west2 = aws.west2
    aws.east = aws.east
  }
}

#Coming Soon
/*
# Add auto-scaling module
module "autoscaling" {
  source = "./modules/autoscaling"

  # Application Load Balancer in east region
  # Auto Scaling Groups for both regions
  # Target Groups for health checks
  # Launch Templates with updated AMIs
}

# Enhanced security features
module "advanced_security" {
  source = "./modules/advanced_security"

  # AWS WAF for web applications
  # GuardDuty threat detection
  # Inspector vulnerability assessments
  # Secrets Manager for sensitive data
  # Parameter Store for configuration
}

# Add network security
module "network_security" {
  source = "./modules/network_security"

  # Network ACLs for additional layer security
  # VPC Flow Logs for network monitoring
  # AWS Shield for DDoS protection
  # Transit Gateway for scalable connectivity
}

module "database" {
  source = "./modules/database"

  # RDS Multi-AZ deployment
  # Cross-region read replicas
  # ElastiCache for Redis
  # DynamoDB with global tables
  # Database backup and encryption
}

module "application_services" {
  source = "./modules/application_services"

  # ECS/Fargate for containerized apps
  # Lambda functions for serverless processing
  # API Gateway for API management
  # S3 buckets for static content
  # CloudFront CDN for global distribution
}

#CI/CD pipeline module

# Add testing module
module "testing" {
  source = "./modules/testing"

  # Terratest for infrastructure testing
  # Compliance checks (CIS benchmarks)
  # Cost estimation and governance
  # Security scanning
}

#Advanced Features

module "analytics" {
  source = "./modules/analytics"

  # Kinesis for real-time data streaming
  # EMR for big data processing
  # Athena for serverless queries
  # QuickSight for business intelligence
}

# Enhanced variable structure
/*
locals {
  environments = {
    dev = {
      instance_type = "t2.micro"
      min_capacity  = 1
      max_capacity  = 2
    }
    staging = {
      instance_type = "t3.small"
      min_capacity  = 2
      max_capacity  = 4
    }
    prod = {
      instance_type = "t3.medium"
      min_capacity  = 3
      max_capacity  = 10
    }
  }
}
*/

/*
# Add enterprise-grade features
module "enterprise" {
  source = "./modules/enterprise"

  # AWS Organizations multi-account setup
  # Service Catalog for standardized deployments
  # AWS Config for compliance monitoring
  # AWS SSO for centralized authentication
}

module "cost_optimization" {
  source = "./modules/cost_optimization"

  # Spot instances for non-critical workloads
  # Scheduled scaling for predictable loads
  # Reserved instance recommendations
  # Lifecycle policies for storage
}
*/

# Output values
output "west_instance_1_private_ip" {
  description = "Private IP of West Region Instance 1"
  value       = module.compute.west_instance_1_private_ip
}

output "west_instance_2_private_ip" {
  description = "Private IP of West Region Instance 2"
  value       = module.compute.west_instance_2_private_ip
}

output "east_instance_1_private_ip" {
  description = "Private IP of East Region Instance 1"
  value       = module.compute.east_instance_1_private_ip
}

output "east_instance_2_private_ip" {
  description = "Private IP of East Region Instance 2"
  value       = module.compute.east_instance_2_private_ip
}

output "east_instance_1_public_ip" {
  description = "Public IP of East Region Instance 1"
  value       = module.compute.east_instance_1_public_ip
}

output "east_instance_2_public_ip" {
  description = "Public IP of East Region Instance 2"
  value       = module.compute.east_instance_2_public_ip
}

# CloudWatch Monitoring Outputs
output "cloudwatch_dashboard_urls" {
  description = "URLs for CloudWatch dashboards in both regions"
  value = {
    west = module.monitoring.west_dashboard_url
    east = module.monitoring.east_dashboard_url
  }
}

output "monitoring_summary" {
  description = "Summary of monitoring resources created"
  value = {
    dashboards = {
      west = module.monitoring.west_dashboard_name
      east = module.monitoring.east_dashboard_name
    }
    log_groups = {
      west = module.monitoring.ssm_log_group_west
      east = module.monitoring.ssm_log_group_east
    }
    cpu_alarms = module.monitoring.cpu_alarm_names
  }
}