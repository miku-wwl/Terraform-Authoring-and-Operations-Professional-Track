#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
aws --endpoint-url="$ENDPOINT" s3api create-bucket --bucket tf-pro-state-localstack --region us-east-1 2>/dev/null || true
echo "S3 bucket 已准备。"
