# Fetch DB password from Secrets Manager
data "aws_secretsmanager_secret" "db_password" {
  name = var.db_password_secret_id
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

# Fetch DB username from Secrets Manager
data "aws_secretsmanager_secret" "db_username" {
  name = var.db_username_secret_id
}

data "aws_secretsmanager_secret_version" "db_username" {
  secret_id = data.aws_secretsmanager_secret.db_username.id
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = [var.private_subnet_id, var.private_subnet_id_2]

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
    Project     = var.project_name
  }
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier           = "${var.project_name}-${var.environment}-db"
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  db_name              = var.db_name
  username             = data.aws_secretsmanager_secret_version.db_username.secret_string
  password             = data.aws_secretsmanager_secret_version.db_password.secret_string
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]
  multi_az             = false
  skip_final_snapshot  = true
  publicly_accessible  = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-db"
    Environment = var.environment
    Project     = var.project_name
  }
}
