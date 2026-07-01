#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

instance_id="$(terraform output -raw instance_id)"
ami_id="$(terraform output -raw selected_ami_id)"

if [ -z "$instance_id" ] || [ -z "$ami_id" ]; then
  echo "验证失败：instance_id 或 selected_ami_id 为空"
  exit 1
fi

aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
  --region "$REGION" \
  --instance-ids "$instance_id" \
  --query "Reservations[].Instances[].ImageId" \
  --output text | grep "$ami_id" >/dev/null

echo "验证通过：实例 $instance_id 使用动态 AMI $ami_id"
