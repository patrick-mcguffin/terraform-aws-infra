aws ec2 create-key-pair \
  --key-name terraform-aws-infra \
  --query "KeyMaterial" \
  --output text > terraform-aws-infra.pem

chmod 400 terraform-aws-infra.pem
