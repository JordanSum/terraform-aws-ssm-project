variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable project_name {
  description = "Name of the project"
  type        = string
  default     = "aws_ssm_project"
}

variable "subnet_one" {
  description = "CIDR block for subnet one"
  type        = string
  
}

variable "subnet_two" {
  description = "CIDR block for subnet two"
  type        = string
  
}

