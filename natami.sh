aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-*" \
  --query "Images | sort_by(@, &CreationDate) | [-1].[ImageId,Name]" \
  --region us-east-1 \
  --output table
