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

aws --endpoint-url="$ENDPOINT" ec2 create-tags \
  --region "$REGION" \
  --resources "$INSTANCE_ID" \
  --tags Key=Owner,Value=external >/dev/null

OWNER_TAG="$(aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
  --region "$REGION" \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[].Instances[].Tags[?Key=='Owner'].Value | [0]" \
  --output text)"

if [ "$OWNER_TAG" != "external" ]; then
  echo "verify failed: Owner tag drift was not created. Current Owner tag is $OWNER_TAG." >&2
  exit 1
fi

set +e
terraform plan -input=false -no-color -detailed-exitcode >drift-check.txt 2>&1
PLAN_EXIT="$?"
set -e

{
  echo "Remote Owner tag after external change: $OWNER_TAG"
  echo
  cat drift-check.txt
} >drift-check.tmp
mv drift-check.tmp drift-check.txt

if [ "$PLAN_EXIT" -ne 0 ]; then
  echo "verify failed: Terraform still wants to reconcile the Owner tag drift. See drift-check.txt." >&2
  exit 1
fi

echo "verify passed: remote Owner tag is external, and ignore_changes kept Terraform plan clean."
