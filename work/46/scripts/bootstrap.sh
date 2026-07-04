#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${TF_VAR_aws_region:-us-east-1}"

export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="$REGION"
export TF_VAR_localstack_endpoint="$ENDPOINT"

aws --endpoint-url="$ENDPOINT" ec2 describe-instances --region "$REGION" >/dev/null

echo "bootstrap ok: EC2 endpoint is ready. No pre-created resource is required for lab 46."
