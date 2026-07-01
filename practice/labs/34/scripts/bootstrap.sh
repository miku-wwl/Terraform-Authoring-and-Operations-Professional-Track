#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="$REGION"

aws --endpoint-url="$ENDPOINT" sts get-caller-identity >/dev/null

for name in tf-lab-ubuntu-2025-01-01-x86_64 tf-lab-ubuntu-2026-01-01-x86_64; do
  exists="$(aws --endpoint-url="$ENDPOINT" ec2 describe-images \
    --region "$REGION" \
    --owners self \
    --filters "Name=name,Values=$name" \
    --query "Images[].ImageId" \
    --output text 2>/dev/null || true)"
  if [ -z "$exists" ]; then
    aws --endpoint-url="$ENDPOINT" ec2 register-image \
      --region "$REGION" \
      --name "$name" \
      --root-device-name /dev/sda1 >/dev/null || true
  fi
done

echo "Lab 34 模拟 AMI 已准备"
