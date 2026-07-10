#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"

export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

STATE=$(terraform state list)
for address in data.aws_caller_identity.base data.aws_caller_identity.assumed aws_s3_bucket.assumed; do
  echo "$STATE" | grep -Fx "$address" >/dev/null
done

test "$(terraform output -raw bucket_name)" = "tf-pro-lab-113"
terraform output -json identity_comparison | grep -q '"changed":true'
terraform output -json identity_comparison | grep -q 'assumed-role/tf-pro-lab-113'
aws --endpoint-url="$ENDPOINT" s3api head-bucket --bucket tf-pro-lab-113 >/dev/null

echo "第 113 节验收通过：已观察到 AssumeRole 前后的身份变化。"
