#!/usr/bin/env sh
set -eu
ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
aws --endpoint-url="$ENDPOINT" sts get-caller-identity >/dev/null
mkdir -p aws-config
cat > aws-config/config <<'EOF'
[profile lab]
region = us-east-1
output = json

[profile audit]
region = us-west-2
output = json
EOF
cat > aws-config/credentials <<'EOF'
[lab]
aws_access_key_id = test
aws_secret_access_key = test

[audit]
aws_access_key_id = test
aws_secret_access_key = test
EOF
echo "AWS lab config files created."
