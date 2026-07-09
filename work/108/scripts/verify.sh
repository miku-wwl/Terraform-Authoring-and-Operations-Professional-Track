#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
export AWS_CONFIG_FILE="$PWD/aws-config/config"
export AWS_SHARED_CREDENTIALS_FILE="$PWD/aws-config/credentials"
aws --profile lab --endpoint-url="$ENDPOINT" sts get-caller-identity >/dev/null
AWS_PROFILE=audit aws --endpoint-url="$ENDPOINT" sts get-caller-identity >/dev/null
AWS_PROFILE=audit aws --profile lab --endpoint-url="$ENDPOINT" sts get-caller-identity >/dev/null
echo "profile verification passed."
