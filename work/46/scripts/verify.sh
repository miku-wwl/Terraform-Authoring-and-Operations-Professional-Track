#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${TF_VAR_aws_region:-us-east-1}"

export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="$REGION"
export TF_VAR_localstack_endpoint="$ENDPOINT"

INSTANCE_ID="$(terraform output -raw web_instance_id)"

if [ -z "$INSTANCE_ID" ]; then
  echo "verify failed: web_instance_id is empty." >&2
  exit 1
fi

PROJECT_TAG=""
for _ in 1 2 3 4 5 6 7 8 9 10 11 12; do
  PROJECT_TAG="$(aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
    --region "$REGION" \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[].Instances[].Tags[?Key=='Project'].Value | [0]" \
    --output text 2>/dev/null || true)"

  if [ "$PROJECT_TAG" = "tf-lab-46" ]; then
    break
  fi

  sleep 2
done

if [ "$PROJECT_TAG" != "tf-lab-46" ]; then
  echo "verify failed: unexpected Project tag $PROJECT_TAG." >&2
  exit 1
fi

aws --endpoint-url="$ENDPOINT" ec2 create-tags \
  --region "$REGION" \
  --resources "$INSTANCE_ID" \
  --tags Key=Owner,Value=external >/dev/null

set +e
terraform plan -input=false -no-color -detailed-exitcode >ignore-check.txt 2>&1
IGNORE_EXIT="$?"
set -e

if [ "$IGNORE_EXIT" -ne 0 ]; then
  echo "verify failed: Owner tag drift was not ignored. See ignore-check.txt." >&2
  exit 1
fi

set +e
TF_VAR_ami_rollout_generation=rollout-2 terraform plan -input=false -no-color -detailed-exitcode >replace-check.txt 2>&1
REPLACE_EXIT="$?"
set -e

if [ "$REPLACE_EXIT" -ne 2 ]; then
  echo "verify failed: rollout generation change did not produce a replacement plan." >&2
  exit 1
fi

if ! grep -q "create replacement and then destroy" replace-check.txt; then
  echo "verify failed: replacement plan did not show create_before_destroy. See replace-check.txt." >&2
  exit 1
fi

set +e
terraform destroy -target=terraform_data.protected_release_marker -auto-approve -input=false -no-color >prevent-destroy-check.txt 2>&1
DESTROY_EXIT="$?"
set -e

if [ "$DESTROY_EXIT" -eq 0 ]; then
  echo "verify failed: protected_release_marker was destroyed. prevent_destroy should block it." >&2
  exit 1
fi

if ! grep -Eq "prevent_destroy|cannot be destroyed|Instance cannot be destroyed" prevent-destroy-check.txt; then
  echo "verify failed: destroy failed, but not because of prevent_destroy. See prevent-destroy-check.txt." >&2
  exit 1
fi

echo "verify passed: ignore_changes, replace_triggered_by, create_before_destroy, and prevent_destroy all behaved as expected."
