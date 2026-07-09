#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
for bucket in tf-pro-lab-105-audit; do
  aws --endpoint-url="$ENDPOINT" s3 rm s3://$bucket --recursive 2>/dev/null || true
  aws --endpoint-url="$ENDPOINT" s3api delete-bucket --bucket $bucket 2>/dev/null || true
done
aws --endpoint-url="$ENDPOINT" dynamodb delete-table --table-name tf-pro-lab-105-platform 2>/dev/null || true
rm -rf .terraform .terraform.lock.hcl tfplan aws-config terraform.tfstate terraform.tfstate.backup
echo "第 105 节本地文件已清理。"

