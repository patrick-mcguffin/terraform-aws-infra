aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$(aws ec2 describe-vpcs --filters Name=tag:Project,Values=terraform-aws-infra --query 'Vpcs[0].VpcId' --output text)" \
  --query "Subnets[*].[SubnetId,AvailabilityZone,CidrBlock]" \
  --output table
