#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
for bucket in tf-pro-lab-112 tf-pro-lab-112-a tf-pro-lab-112-b tf-pro-lab-112-dev tf-pro-lab-112-prod; do
  aws --endpoint-url="$ENDPOINT" s3 rm s3://$bucket --recursive 2>/dev/null || true
  aws --endpoint-url="$ENDPOINT" s3api delete-bucket --bucket $bucket 2>/dev/null || true
done
rm -rf .terraform .terraform.lock.hcl .terraform.tfstate.lock.info tfplan aws-config terraform.tfstate terraform.tfstate.backup
echo "第 112 节本地文件已清理。"

