#!/usr/bin/env sh
set -eu
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
export LOCALSTACK_ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
export TF_VAR_localstack_endpoint="${TF_VAR_localstack_endpoint:-$LOCALSTACK_ENDPOINT}"
echo "LocalStack endpoint: $LOCALSTACK_ENDPOINT"
