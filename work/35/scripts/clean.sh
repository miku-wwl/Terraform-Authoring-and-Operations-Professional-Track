#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

ids="$(aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
  --region "$REGION" \
  --filters "Name=tag:Project,Values=tf-lab-35" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text 2>/dev/null || true)"

if [ -n "$ids" ]; then
  aws --endpoint-url="$ENDPOINT" ec2 terminate-instances --region "$REGION" --instance-ids $ids >/dev/null || true
fi

images="$(aws --endpoint-url="$ENDPOINT" ec2 describe-images \
  --region "$REGION" \
  --owners self \
  --filters "Name=name,Values=tf-lab-app-*-x86_64" \
  --query "Images[].ImageId" \
  --output text 2>/dev/null || true)"

for id in $images; do
  aws --endpoint-url="$ENDPOINT" ec2 deregister-image --region "$REGION" --image-id "$id" >/dev/null || true
done

rm -rf .terraform .terraform.lock.hcl tfplan terraform.tfstate terraform.tfstate.backup
echo "Lab 35 清理完成"
