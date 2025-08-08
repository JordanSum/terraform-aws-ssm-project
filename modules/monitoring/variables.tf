variable "project_name" {
  description = "The name of the project"
  type        = string
}

# West region instance IDs
variable "west_instance_1_id" {
  description = "The instance ID for West region instance 1"
  type        = string
}

variable "west_instance_2_id" {
  description = "The instance ID for West region instance 2"
  type        = string
}

# East region instance IDs
variable "east_instance_1_id" {
  description = "The instance ID for East region instance 1"
  type        = string
}

variable "east_instance_2_id" {
  description = "The instance ID for East region instance 2"
  type        = string
}

# Environment for tagging
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}