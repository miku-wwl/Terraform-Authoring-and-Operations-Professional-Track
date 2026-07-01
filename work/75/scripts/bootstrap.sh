#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
aws --endpoint-url="$ENDPOINT" s3api create-bucket --bucket tf-pro-state-localstack --region us-east-1 2>/dev/null || true
aws --endpoint-url="$ENDPOINT" dynamodb create-table --table-name tf-pro-lock-localstack --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region us-east-1 2>/dev/null || true
echo "S3 bucket 和 DynamoDB lock table 已准备。"
