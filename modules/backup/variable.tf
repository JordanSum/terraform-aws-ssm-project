variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "west_instance_1_id" {
  description = "The instance ID for West region instance 1"
  type        = string
}

variable "west_instance_2_id" {
  description = "The instance ID for West region instance 2"
  type        = string
}

variable "east_instance_1_id" {
  description = "The instance ID for East region instance 1"
  type        = string
}

variable "east_instance_2_id" {
  description = "The instance ID for East region instance 2"
  type        = string
}

variable "backup_iam_role_arn" {
  description = "The ARN of the IAM role for AWS Backup"
  type        = string
}
