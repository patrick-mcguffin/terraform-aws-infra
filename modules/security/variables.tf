variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "my_ip" {
  description = "Your IP address for SSH access"
  type        = string
}
