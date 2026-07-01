#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

count="$(aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
  --region "$REGION" \
  --filters "Name=tag:Project,Values=tf-lab-31" \
  --query "length(Reservations[].Instances[])" \
  --output text)"

tf_count="$(terraform output -raw lab_instance_count)"

if [ "$count" -lt 2 ]; then
  echo "验证失败：LocalStack 中少于 2 台 tf-lab-31 实例"
  exit 1
fi

if [ "$tf_count" -lt 2 ]; then
  echo "验证失败：Terraform data source 输出少于 2 台实例"
  exit 1
fi

echo "验证通过：data source 读取到 $tf_count 台实例"
