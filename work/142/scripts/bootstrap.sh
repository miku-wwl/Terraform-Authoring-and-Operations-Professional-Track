#!/usr/bin/env sh
set -eu
mkdir -p aws-config
printf '%s
' '[profile base]' 'region = us-east-1' 'output = json' '' '[profile lab-142]' 'region = us-east-1' 'source_profile = base' 'role_arn = arn:aws:iam::000000000000:role/tf-pro-lab-142-demo' > aws-config/config
printf '%s
' '[base]' 'aws_access_key_id = test' 'aws_secret_access_key = test' > aws-config/credentials
echo '已创建 aws-config/config 和 aws-config/credentials。'
