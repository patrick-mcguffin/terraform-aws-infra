aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" \
  --query "Images | sort_by(@, &CreationDate) | [-1].ImageId" \
  --region us-east-1
