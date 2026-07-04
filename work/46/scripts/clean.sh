#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${TF_VAR_aws_region:-us-east-1}"

export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="$REGION"
export TF_VAR_localstack_endpoint="$ENDPOINT"

if terraform state list >/tmp/tf-lab-46-state-list.txt 2>/dev/null; then
  if grep -qx "terraform_data.protected_release_marker" /tmp/tf-lab-46-state-list.txt; then
    terraform state rm terraform_data.protected_release_marker >/dev/null
  fi
fi

terraform destroy -auto-approve -input=false

INSTANCE_IDS="$(aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
  --region "$REGION" \
  --filters Name=tag:Project,Values=tf-lab-46 Name=instance-state-name,Values=pending,running,stopping,stopped \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)"

if [ -n "$INSTANCE_IDS" ] && [ "$INSTANCE_IDS" != "None" ]; then
  aws --endpoint-url="$ENDPOINT" ec2 terminate-instances --region "$REGION" --instance-ids $INSTANCE_IDS >/dev/null
fi

rm -f tfplan ignore-check.txt replace-check.txt prevent-destroy-check.txt /tmp/tf-lab-46-state-list.txt

echo "clean ok: Terraform-managed resources and residual tf-lab-46 EC2 instances were removed."
