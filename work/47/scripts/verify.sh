#!/usr/bin/env sh
set -eu

set +e
terraform plan -var="image_version=v2" -input=false -no-color -detailed-exitcode >replace-check.txt 2>&1
PLAN_EXIT="$?"
set -e

if [ "$PLAN_EXIT" -ne 2 ]; then
  echo "verify failed: image_version=v2 did not create a replacement plan. See replace-check.txt." >&2
  exit 1
fi

if ! grep -q "must be replaced" replace-check.txt; then
  echo "verify failed: plan did not say terraform_data.service_release must be replaced. See replace-check.txt." >&2
  exit 1
fi

if ! grep -q "create replacement and then destroy" replace-check.txt; then
  echo "verify failed: plan did not show create_before_destroy order. See replace-check.txt." >&2
  exit 1
fi

echo "verify passed: triggers_replace caused replacement, and create_before_destroy changed replacement order."
