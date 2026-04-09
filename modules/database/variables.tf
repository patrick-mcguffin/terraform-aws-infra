variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "rds_sg_id" {
  description = "ID of the RDS security group"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
}

variable "db_password_secret_id" {
  description = "Secrets Manager secret ID for the DB password"
  type        = string
}

variable "db_username_secret_id" {
  description = "Secrets Manager secret ID for the DB username"
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

variable "private_subnet_id_2" {
  description = "ID of the second private subnet"
  type        = string
}
