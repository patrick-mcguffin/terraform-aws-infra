output "nat_sg_id" {
  description = "ID of the NAT instance security group"
  value       = aws_security_group.nat.id
}

output "nginx_sg_id" {
  description = "ID of the Nginx security group"
  value       = aws_security_group.nginx.id
}

output "web_sg_id" {
  description = "ID of the web server security group"
  value       = aws_security_group.web.id
}

output "rds_sg_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2.name
}
