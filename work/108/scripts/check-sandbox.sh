#!/usr/bin/env sh
set -eu
terraform version >/dev/null
aws --version >/dev/null
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
aws --endpoint-url="$ENDPOINT" sts get-caller-identity >/dev/null
echo "LocalStack 连接正常。"
