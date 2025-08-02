variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block of the VPC"
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

variable "vpc_endpoint_sg" {
  description = "Security Group ID for VPC endpoints"
  type        = string
  
}