#!/usr/bin/env sh
set -eu

name="$(terraform output -raw iam_user_name)"
reset_required="$(terraform output -raw password_reset_required)"
access_key_id="$(terraform output -raw access_key_id)"
access_key_status="$(terraform output -raw access_key_status)"
access_key_secret="$(terraform output -raw access_key_secret)"
console_password="$(terraform output -raw generated_console_password)"

[ "$name" = 'tf-pro-lab-134-operator' ] || {
  echo "Unexpected IAM user: $name" >&2
  exit 1
}

[ "$reset_required" = 'true' ] || {
  echo "Expected password_reset_required=true, got $reset_required" >&2
  exit 1
}

[ -n "$access_key_id" ] || { echo 'Access Key ID must not be empty.' >&2; exit 1; }
[ "$access_key_status" = 'Active' ] || { echo "Expected Access Key status Active, got $access_key_status" >&2; exit 1; }
[ -n "$access_key_secret" ] || { echo 'Secret Access Key must not be empty.' >&2; exit 1; }
[ "${#console_password}" -ge 20 ] || { echo 'Generated console password must be at least 20 characters.' >&2; exit 1; }

echo 'PASS: IAM user, login profile, access key, dependency outputs, and secret lengths are correct.'
echo 'Secret values were checked without printing them.'
