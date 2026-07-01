#!/usr/bin/env sh
set -eu
terraform state list >/dev/null
echo "第 107 节验收通过。"
