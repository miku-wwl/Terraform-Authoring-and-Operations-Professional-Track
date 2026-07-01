#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
terraform state list >/dev/null
aws --endpoint-url="$ENDPOINT" s3api head-object --bucket tf-pro-state-localstack --key labs/77/terraform.tfstate >/dev/null
echo "第 77 节验收通过。"
