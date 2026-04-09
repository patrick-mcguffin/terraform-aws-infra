variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "nginx_sg_id" {
  description = "ID of the Nginx security group"
  type        = string
}

variable "web_sg_id" {
  description = "ID of the web server security group"
  type        = string
}

variable "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  type        = string
}

variable "rds_port" {
  description = "Port of the RDS instance"
  type        = number
}

variable "db_name" {
  description = "Name of the database"
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
