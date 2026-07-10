#!/usr/bin/env sh
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1 AWS_REGION=us-east-1
unset AWS_SESSION_TOKEN AWS_PROFILE
export LOCALSTACK_ENDPOINT=http://localhost:4566 TF_VAR_localstack_endpoint=http://localhost:4566 TF_VAR_aws_region=us-east-1
