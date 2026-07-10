#!/usr/bin/env sh
set -eu
sh scripts/check-sandbox.sh
[ "$(aws configure get region --profile base)" = us-east-1 ]
[ "$(aws configure get output --profile base)" = json ]
[ "$(aws configure get source_profile --profile lab-142)" = base ]
[ "$(aws configure get role_arn --profile lab-142)" = arn:aws:iam::000000000000:role/tf-pro-lab-142-demo ]
[ "$(aws configure get aws_access_key_id --profile base)" = test ]
[ "$(aws configure get aws_secret_access_key --profile base)" = test ]
echo 'PASS: AWS CLI parsed the isolated source_profile chain without a network call.'
