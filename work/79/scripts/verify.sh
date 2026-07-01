#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
(cd consumer && terraform output >/dev/null)
aws --endpoint-url="$ENDPOINT" s3api head-object --bucket tf-pro-state-localstack --key labs/79/network/terraform.tfstate >/dev/null
aws --endpoint-url="$ENDPOINT" s3api head-object --bucket tf-pro-state-localstack --key labs/79/consumer/terraform.tfstate >/dev/null
echo "第 79 节验收通过。"
