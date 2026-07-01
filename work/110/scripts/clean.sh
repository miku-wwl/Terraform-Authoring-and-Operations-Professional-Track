#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
for bucket in tf-pro-lab-110 tf-pro-lab-110-a tf-pro-lab-110-b tf-pro-lab-110-dev tf-pro-lab-110-prod; do
  aws --endpoint-url="$ENDPOINT" s3 rm s3://$bucket --recursive 2>/dev/null || true
  aws --endpoint-url="$ENDPOINT" s3api delete-bucket --bucket $bucket 2>/dev/null || true
done
rm -rf .terraform .terraform.lock.hcl tfplan aws-config terraform.tfstate terraform.tfstate.backup
echo "第 110 节本地文件已清理。"

