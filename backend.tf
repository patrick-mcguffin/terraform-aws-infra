terraform {
  backend "s3" {
    bucket         = "backend-bucket-432026"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
