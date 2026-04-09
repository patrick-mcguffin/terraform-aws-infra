output "nginx_public_ip" {
  description = "Public IP of the Nginx instance"
  value       = aws_eip.nginx.public_ip
}

output "web_private_ip" {
  description = "Private IP of the web server"
  value       = aws_instance.web.private_ip
}

output "nginx_instance_id" {
  description = "ID of the Nginx instance"
  value       = aws_instance.nginx.id
}

output "web_instance_id" {
  description = "ID of the web server instance"
  value       = aws_instance.web.id
}
