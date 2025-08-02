variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}


variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "subnet_one" {
  description = "CIDR block for subnet one"
  type        = string
  }

variable "subnet_two" {
  description = "CIDR block for subnet two"
  type        = string
  
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}