#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${TF_VAR_aws_region:-us-east-1}"

export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="$REGION"

aws --endpoint-url="$ENDPOINT" sts get-caller-identity --region "$REGION" >/dev/null

echo "sandbox ok: LocalStack STS endpoint is reachable at $ENDPOINT."
