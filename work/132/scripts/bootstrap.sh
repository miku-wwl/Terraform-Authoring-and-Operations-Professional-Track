#!/usr/bin/env sh

# Source this file: `. ./scripts/bootstrap.sh`
# Running it as a child process cannot export variables back to the parent shell.
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
unset AWS_SESSION_TOKEN
unset AWS_PROFILE
export AWS_DEFAULT_REGION=us-east-1
export AWS_REGION=us-east-1
export LOCALSTACK_ENDPOINT=http://localhost:4566
export TF_VAR_localstack_endpoint="$LOCALSTACK_ENDPOINT"
export TF_VAR_aws_region="$AWS_DEFAULT_REGION"

echo 'Prepared LocalStack test/test credentials in the current shell.'
echo "LocalStack endpoint: $LOCALSTACK_ENDPOINT"
