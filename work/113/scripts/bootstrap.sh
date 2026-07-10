#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

aws --endpoint-url="$ENDPOINT" sts get-caller-identity >/dev/null

if ! aws --endpoint-url="$ENDPOINT" iam get-role --role-name tf-pro-lab-113 >/dev/null 2>&1; then
  aws --endpoint-url="$ENDPOINT" iam create-role \
    --role-name tf-pro-lab-113 \
    --assume-role-policy-document "file://$SCRIPT_DIR/assume-role-trust-policy.json" >/dev/null
fi

echo "实验环境已准备：IAM Role tf-pro-lab-113 已存在。"
