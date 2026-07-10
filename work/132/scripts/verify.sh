#!/usr/bin/env sh
set -eu

account_id="$(terraform output -raw account_id)"
user_id="$(terraform output -raw caller_user_id)"
caller_arn="$(terraform output -raw caller_arn)"
role_arn="$(terraform output -raw example_role_arn)"
is_localstack="$(terraform output -raw is_localstack)"

[ "$account_id" = '000000000000' ] || {
  echo "Expected LocalStack account 000000000000, got $account_id." >&2
  exit 1
}

[ -n "$user_id" ] || {
  echo 'caller_user_id must not be empty.' >&2
  exit 1
}

case "$caller_arn" in
  arn:aws:iam::000000000000:*|arn:aws:sts::000000000000:*) ;;
  *)
    echo "Unexpected LocalStack caller ARN: $caller_arn" >&2
    exit 1
    ;;
esac

[ "$role_arn" = 'arn:aws:iam::000000000000:role/platform-deployer' ] || {
  echo "example_role_arn was not built from the caller account: $role_arn" >&2
  exit 1
}

[ "$is_localstack" = 'true' ] || {
  echo "Expected is_localstack=true, got $is_localstack." >&2
  exit 1
}

echo 'PASS: LocalStack caller identity and derived ARN are correct.'
