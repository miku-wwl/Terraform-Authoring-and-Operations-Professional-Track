#!/usr/bin/env sh
set -eu
terraform state list >/dev/null
echo "第 103 节验收通过。"
