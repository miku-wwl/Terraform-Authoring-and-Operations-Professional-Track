#!/usr/bin/env sh
# Source this file from work/142: `. ./scripts/bootstrap.sh`
lab_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
export AWS_CONFIG_FILE="$lab_root/aws-config/config"
export AWS_SHARED_CREDENTIALS_FILE="$lab_root/aws-config/credentials"
export AWS_EC2_METADATA_DISABLED=true
unset AWS_PROFILE AWS_DEFAULT_PROFILE
echo 'AWS CLI now uses only the isolated Lab 142 config files.'
