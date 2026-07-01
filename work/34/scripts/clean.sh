#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

ids="$(aws --endpoint-url="$ENDPOINT" ec2 describe-images \
  --region "$REGION" \
  --owners self \
  --filters "Name=name,Values=tf-lab-ubuntu-*-x86_64" \
  --query "Images[].ImageId" \
  --output text 2>/dev/null || true)"

for id in $ids; do
  aws --endpoint-url="$ENDPOINT" ec2 deregister-image --region "$REGION" --image-id "$id" >/dev/null || true
done

rm -rf .terraform .terraform.lock.hcl tfplan terraform.tfstate terraform.tfstate.backup
echo "Lab 34 清理完成"
