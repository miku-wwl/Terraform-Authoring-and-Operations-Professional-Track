#!/usr/bin/env sh
set -eu
terraform output >/dev/null
echo '验证通过：Terraform 输出存在。'
