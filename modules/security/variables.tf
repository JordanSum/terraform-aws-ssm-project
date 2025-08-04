variable "vpc_id_west" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_id_east" {
  description = "The ID of the VPC in the East Coast"
  type        = string
}

variable "cidr_block_west" {
  description = "The CIDR block of the VPC"
  type        = string
  
}

variable "cidr_block_east" {
  description = "The CIDR block of the VPC in the East Coast"
  type        = string
  
}

variable "subnet_one_west" {
  description = "The ID of subnet one"
  type        = string
  
}

variable "subnet_two_west" {
  description = "The ID of subnet two"
  type        = string
  
}

variable "subnet_one_east" {
  description = "The ID of subnet one in East region"
  type        = string
  
}

variable "subnet_two_east" {
  description = "The ID of subnet two in East region"
  type        = string
  
}
