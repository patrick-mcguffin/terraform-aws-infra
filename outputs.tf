# Networking Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.networking.private_subnet_id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway"
  value       = module.networking.internet_gateway_id
}

output "nat_instance_id" {
  description = "ID of the NAT instance"
  value       = module.networking.nat_instance_id
}

# Security Outputs
output "nginx_sg_id" {
  description = "ID of the Nginx security group"
  value       = module.security.nginx_sg_id
}

output "web_sg_id" {
  description = "ID of the web server security group"
  value       = module.security.web_sg_id
}

output "rds_sg_id" {
  description = "ID of the RDS security group"
  value       = module.security.rds_sg_id
}

# Compute Outputs
output "nginx_public_ip" {
  description = "Public IP of the Nginx instance - open this in your browser"
  value       = module.compute.nginx_public_ip
}

output "web_private_ip" {
  description = "Private IP of the web server"
  value       = module.compute.web_private_ip
}

output "nginx_instance_id" {
  description = "ID of the Nginx instance"
  value       = module.compute.nginx_instance_id
}

output "web_instance_id" {
  description = "ID of the web server instance"
  value       = module.compute.web_instance_id
}

# Database Outputs
output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.database.rds_endpoint
}

output "rds_port" {
  description = "Port of the RDS instance"
  value       = module.database.rds_port
}

output "db_name" {
  description = "Name of the database"
  value       = module.database.db_name
}
