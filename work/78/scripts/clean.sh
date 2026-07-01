#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
aws --endpoint-url="$ENDPOINT" s3 rm s3://tf-pro-state-localstack/labs/78/ --recursive 2>/dev/null || true
rm -rf network/.terraform network/.terraform.lock.hcl network/backend.hcl network/tfplan consumer/.terraform consumer/.terraform.lock.hcl consumer/backend.hcl consumer/tfplan
echo "第 78 节本地实验文件已清理。"
