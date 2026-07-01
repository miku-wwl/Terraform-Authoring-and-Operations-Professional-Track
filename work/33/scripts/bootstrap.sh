#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="$REGION"

aws --endpoint-url="$ENDPOINT" sts get-caller-identity >/dev/null

existing="$(aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
  --region "$REGION" \
  --filters "Name=tag:Project,Values=tf-lab-33" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)"

if [ -z "$existing" ]; then
  aws --endpoint-url="$ENDPOINT" ec2 run-instances \
    --region "$REGION" \
    --image-id ami-tf-lab-33 \
    --instance-type t3.micro \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=tf-lab-33-prod},{Key=Project,Value=tf-lab-33},{Key=Team,Value=production}]" >/dev/null

  aws --endpoint-url="$ENDPOINT" ec2 run-instances \
    --region "$REGION" \
    --image-id ami-tf-lab-33 \
    --instance-type t3.micro \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=tf-lab-33-dev},{Key=Project,Value=tf-lab-33},{Key=Team,Value=development}]" >/dev/null
fi

echo "Lab 33 前置 EC2 已准备"
