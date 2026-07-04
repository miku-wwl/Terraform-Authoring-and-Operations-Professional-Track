#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="$REGION"
export TF_VAR_localstack_endpoint="$ENDPOINT"

aws --endpoint-url="$ENDPOINT" sts get-caller-identity >/dev/null
echo "Lab45 不需要预创建资源；LocalStack EC2 endpoint 已就绪。"
