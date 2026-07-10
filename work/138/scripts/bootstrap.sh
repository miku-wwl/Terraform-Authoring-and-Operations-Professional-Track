#!/usr/bin/env sh
# Source this file: `. ./scripts/bootstrap.sh`
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1 AWS_REGION=us-east-1
unset AWS_SESSION_TOKEN AWS_PROFILE
export LOCALSTACK_ENDPOINT=http://localhost:4566
export TF_VAR_localstack_endpoint="$LOCALSTACK_ENDPOINT" TF_VAR_aws_region="$AWS_DEFAULT_REGION"
echo 'Prepared LocalStack test/test credentials in the current shell.'
