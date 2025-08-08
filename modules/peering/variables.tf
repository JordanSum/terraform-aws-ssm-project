variable "project_name" {
  description = "Name of the project"
  type        = string

}

variable "enable_vpc_peering" {
  description = "Enable VPC peering between regions"
  type        = bool
  default     = false
}

variable "vpc_id_west" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_id_east" {
  description = "The ID of the VPC in the East Coast"
  type        = string
}

variable "cidr_block_west" {
  description = "CIDR block for west VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cidr_block_east" {
  description = "CIDR block for east VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "route_table_ids_west" {
  description = "List of route table IDs for the west VPC"
  type        = list(string)
}

variable "route_table_ids_east" {
  description = "List of route table IDs for the east VPC"
  type        = list(string)
}