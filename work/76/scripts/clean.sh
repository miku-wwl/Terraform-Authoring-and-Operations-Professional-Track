#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
aws --endpoint-url="$ENDPOINT" s3 rm s3://tf-pro-state-localstack/labs/76/ --recursive 2>/dev/null || true
rm -rf .terraform .terraform.lock.hcl backend.hcl tfplan
echo "第 76 节本地实验文件已清理。"
