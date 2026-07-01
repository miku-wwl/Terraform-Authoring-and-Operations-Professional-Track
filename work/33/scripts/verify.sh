#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

prod_id="$(terraform output -raw production_instance_id)"
count="$(terraform output -raw all_lab_instance_count)"

if [ -z "$prod_id" ]; then
  echo "验证失败：生产实例 ID 为空"
  exit 1
fi

if [ "$count" -lt 2 ]; then
  echo "验证失败：全部实验实例少于 2 台"
  exit 1
fi

aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
  --region "$REGION" \
  --instance-ids "$prod_id" \
  --query "Reservations[].Instances[].Tags" \
  --output json >/dev/null

echo "验证通过：单实例 $prod_id，多实例数量 $count"
