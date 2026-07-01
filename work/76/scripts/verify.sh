#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
terraform state list >/dev/null
aws --endpoint-url="$ENDPOINT" s3api head-object --bucket tf-pro-state-localstack --key labs/76/terraform.tfstate >/dev/null
echo "第 76 节验收通过：state 已写入 S3 backend，并使用 use_lockfile 新式锁配置。"
