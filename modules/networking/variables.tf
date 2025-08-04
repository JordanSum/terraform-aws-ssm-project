variable "cidr_block_west" {
  description = "CIDR block for VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "cidr_block_east" {
  description = "CIDR block for VPC in the East region"
  type        = string
  default     = "10.0.0.0/16"
}

variable project_name {
  description = "Name of the project"
  type        = string
  default     = "aws_ssm_project"
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

