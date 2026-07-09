#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
aws --endpoint-url="$ENDPOINT" sts get-caller-identity >/dev/null
echo "实验预检完成。"
