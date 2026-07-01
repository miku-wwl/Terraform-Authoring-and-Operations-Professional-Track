#!/usr/bin/env sh
set -eu
test -f aws-config/config
grep -q 'source_profile = base' aws-config/config
grep -q 'role_arn = arn:aws:iam::000000000000:role/tf-pro-lab-142-demo' aws-config/config
echo '验证通过：AWS CLI source_profile 配置已生成。'
