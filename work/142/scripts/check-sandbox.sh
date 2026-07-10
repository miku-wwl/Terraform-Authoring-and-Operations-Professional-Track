#!/usr/bin/env sh
set -eu
lab_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
[ "${AWS_CONFIG_FILE:-}" = "$lab_root/aws-config/config" ]
[ "${AWS_SHARED_CREDENTIALS_FILE:-}" = "$lab_root/aws-config/credentials" ]
[ "${AWS_EC2_METADATA_DISABLED:-}" = true ]
command -v aws >/dev/null 2>&1
echo 'PASS: AWS CLI paths are isolated and metadata lookup is disabled.'
