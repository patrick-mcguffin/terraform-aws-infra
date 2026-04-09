# Nginx EC2 Instance
resource "aws_instance" "nginx" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.nginx_sg_id]
  key_name               = var.key_pair_name
  iam_instance_profile   = var.ec2_instance_profile_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl start nginx
    systemctl enable nginx

    # Configure Nginx as reverse proxy
    cat > /etc/nginx/conf.d/proxy.conf <<'NGINX'
    server {
      listen 80;

      location / {
        proxy_pass http://${aws_instance.web.private_ip};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
      }
    }
    NGINX

    systemctl restart nginx
  EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-nginx"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Elastic IP for Nginx
resource "aws_eip" "nginx" {
  instance = aws_instance.nginx.id
  domain   = "vpc"

  tags = {
    Name        = "${var.project_name}-${var.environment}-nginx-eip"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Web Server EC2 Instance
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.web_sg_id]
  key_name               = var.key_pair_name
  iam_instance_profile   = var.ec2_instance_profile_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3 python3-pip

    # Set DB environment variables
    echo "export DB_HOST=${var.rds_endpoint}" >> /etc/environment
    echo "export DB_PORT=${var.rds_port}" >> /etc/environment
    echo "export DB_NAME=${var.db_name}" >> /etc/environment

    # Create a simple Python web app
    mkdir -p /app
    cat > /app/app.py <<'APP'
    from http.server import HTTPServer, BaseHTTPRequestHandler

    class Handler(BaseHTTPRequestHandler):
      def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Hello from the web server!")

    HTTPServer(("0.0.0.0", 80), Handler).serve_forever()
    APP

    python3 /app/app.py &
  EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-web"
    Environment = var.environment
    Project     = var.project_name
  }
}
