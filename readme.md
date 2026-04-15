# Terraform AWS Infrastructure

(https://github.com/YOURUSERNAME/terraform-aws-infra/actions/workflows/terraform.yml/badge.svg)

A production-style, multi-tier AWS infrastructure built with Terraform and deployed via a CI/CD pipeline using GitHub Actions. Designed to demonstrate real-world cloud engineering practices while staying within the AWS Free Tier.

---

## Architecture


The infrastructure consists of a public subnet containing an Nginx reverse proxy and NAT Instance, and a private subnet containing a web server and RDS PostgreSQL database. All traffic from the internet flows through Nginx, which proxies requests to the web server. The web server communicates with the database over a private connection that never touches the public internet.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| AWS VPC | Network isolation |
| AWS EC2 | Nginx reverse proxy and web server |
| AWS RDS | PostgreSQL database |
| AWS Secrets Manager | Secure credential storage |
| AWS IAM | Least-privilege access control |
| AWS S3 | Terraform remote state storage |
| AWS DynamoDB | Terraform state locking |
| GitHub Actions | CI/CD pipeline |

---

## Project Structure

```
terraform-aws-infra/
├── main.tf                    # Root module, wires all modules together
├── variables.tf               # Input variable declarations
├── outputs.tf                 # Output value declarations
├── backend.tf                 # Remote state configuration
├── terraform.tfvars           # Variable values (gitignored)
├── .github/
│   └── workflows/
│       └── terraform.yml      # CI/CD pipeline
└── modules/
    ├── networking/            # VPC, subnets, IGW, NAT instance, route tables
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security/              # Security groups, IAM roles, instance profiles
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── database/              # RDS instance, subnet group, Secrets Manager integration
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── compute/               # Nginx and web server EC2 instances, Elastic IPs
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.7.0 or later
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- An AWS account with appropriate permissions
- A GitHub account

---

## How to Deploy

### 1. Clone the Repository
```bash
git clone https://github.com/patrick-mcguffin/terraform-aws-infra.git
cd terraform-aws-infra
```

### 2. Create the S3 Bucket for Remote State
```bash
aws s3api create-bucket \
  --bucket your-terraform-state-bucket \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

aws s3api put-public-access-block \
  --bucket your-terraform-state-bucket \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

aws s3api put-bucket-encryption \
  --bucket your-terraform-state-bucket \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'
```

### 3. Create the DynamoDB Table for State Locking
```bash
aws dynamodb create-table \
  --table-name terraform-state-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

### 4. Store Database Credentials in Secrets Manager
```bash
aws secretsmanager create-secret \
  --name "terraform-aws-infra/dev/db/password" \
  --secret-string "yourpassword" \
  --region us-east-1

aws secretsmanager create-secret \
  --name "terraform-aws-infra/dev/db/username" \
  --secret-string "yourusername" \
  --region us-east-1
```

### 5. Create an EC2 Key Pair
```bash
aws ec2 create-key-pair \
  --key-name terraform-aws-infra \
  --query "KeyMaterial" \
  --output text > terraform-aws-infra.pem

chmod 400 terraform-aws-infra.pem
```

### 6. Configure Variables
Create a `terraform.tfvars` file in the project root:
```hcl
aws_region            = "us-east-1"
environment           = "dev"
vpc_cidr              = "10.0.0.0/16"
public_subnet_cidr    = "10.0.1.0/24"
private_subnet_cidr   = "10.0.2.0/24"
private_subnet_cidr_2 = "10.0.3.0/24"
availability_zones    = ["us-east-1a", "us-east-1b"]
instance_type         = "t2.micro"
db_instance_class     = "db.t3.micro"
db_name               = "mydb"
db_allocated_storage  = 20
project_name          = "terraform-aws-infra"
owner                 = "Your Name"
```

### 7. Deploy
```bash
terraform init
terraform apply
```

---

## How to Destroy
Always destroy resources when not in use to avoid charges:
```bash
terraform destroy
```
This is a standard practice in professional environments for non-production infrastructure.

---

## CI/CD Pipeline

The GitHub Actions pipeline is split into two jobs:

**Validate** — runs automatically on every push and pull request:
- `terraform fmt` — checks code formatting
- `terraform init` — initializes the backend
- `terraform validate` — checks for syntax errors
- `terraform plan` — previews infrastructure changes

**Apply** — runs on push to main only, requires manual approval:
- A reviewer must approve the deployment in the GitHub Actions tab before apply runs
- This prevents unintended infrastructure changes and mirrors real-world deployment workflows

---

## Cost Optimization Decisions

| Production Choice | Free Tier Swap | Monthly Savings |
|---|---|---|
| NAT Gateway | NAT Instance (t2.micro) | ~$32 |
| Application Load Balancer | Nginx on EC2 | ~$6 |
| RDS Multi-AZ | Single-AZ | ~50% RDS cost |

---

## Security Decisions

**Credentials** — Database credentials are stored in AWS Secrets Manager and fetched at apply time. They are never written to Terraform files or state.

**Network isolation** — The web server and RDS instance live in private subnets with no direct internet access. All inbound traffic flows through the Nginx reverse proxy.

**Security groups** — Each tier only accepts traffic from the tier directly above it. RDS only accepts connections from the web server, and the web server only accepts connections from Nginx.

**IAM** — EC2 instances use IAM roles with least-privilege policies. Roles are scoped to only the permissions each instance needs.

---

## Future Improvements

- Replace NAT Instance with a managed NAT Gateway for higher availability
- Add an Application Load Balancer for better traffic distribution and health checks
- Enable RDS Multi-AZ for automatic failover
- Add Infracost to the CI/CD pipeline for cost estimation on every PR
- Enable Secrets Manager automatic credential rotation
- Add CloudWatch dashboards and alerting for infrastructure monitoring

---

## Author

Patrick McGuffin
[GitHub](https://github.com/YOURUSERNAME) | [LinkedIn](https://linkedin.com/in/YOURLINKEDIN)