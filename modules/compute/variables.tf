variable "subnet_one_west" {
  description = "The ID of the subnet where the EC2 instance will be launched"
  type        = string
}

variable "subnet_two_west" {
  description = "The ID of the second subnet where the EC2 instance will be launched"
  type        = string
}

variable "subnet_one_east" {
  description = "The ID of the subnet in the East Coast where the EC2 instance will be launched"
  type        = string
}

variable "subnet_two_east" {
  description = "The ID of the second subnet in the East Coast where the EC2 instance will be launched"
  type        = string
}

variable "iam_profile" {
  description = "The IAM profile to attach to the EC2 instance"
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

variable "instance_SG_west" {
  description = "Security Group ID for the EC2 instances in West region"
  type        = string

}

variable "instance_SG_east" {
  description = "Security Group ID for the EC2 instances in East region"
  type        = string

}