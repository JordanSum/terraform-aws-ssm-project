variable "subnet_one" {
  description = "The ID of the subnet where the EC2 instance will be launched"
  type        = string
}

variable "subnet_two" {
  description = "The ID of the second subnet where the EC2 instance will be launched"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EC2 instances and subnets are located"
  type        = string
}

variable "iam_profile" {
  description = "The IAM profile to attach to the EC2 instance"
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

variable "instance_SG" {
  description = "Security Group ID for the EC2 instance"
  type        = string
  
}