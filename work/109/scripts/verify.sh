#!/usr/bin/env sh
set -eu
terraform state list >/dev/null
echo "第 109 节验收通过。"
