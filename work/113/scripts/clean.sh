#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"

export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

aws --endpoint-url="$ENDPOINT" s3 rm s3://tf-pro-lab-113 --recursive 2>/dev/null || true
aws --endpoint-url="$ENDPOINT" s3api delete-bucket --bucket tf-pro-lab-113 2>/dev/null || true
aws --endpoint-url="$ENDPOINT" iam delete-role --role-name tf-pro-lab-113 2>/dev/null || true
rm -rf .terraform .terraform.lock.hcl tfplan terraform.tfstate terraform.tfstate.backup
echo "第 113 节环境已清理。"
