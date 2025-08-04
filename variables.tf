variable "cidr_block_west" {
  description = "CIDR block for VPC"
  type        = string
}

variable "cidr_block_east" {
  description = "CIDR block for VPC in the East region"
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

variable "subnet_one_west" {
  description = "CIDR block for subnet one"
  type        = string
}

variable "subnet_two_west" {
  description = "CIDR block for subnet two"
  type        = string

}

variable "subnet_one_east" {
  description = "CIDR block for subnet one in the East Coast"
  type        = string

}

variable "subnet_two_east" {
  description = "CIDR block for subnet two in the East Coast"
  type        = string

}

variable "ami_id_west" {
  description = "AMI ID for EC2 instances"
  type        = string

}

variable "ami_id_east" {
  description = "AMI ID for EC2 instances in the East region"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}