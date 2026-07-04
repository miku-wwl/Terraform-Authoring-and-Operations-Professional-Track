#!/usr/bin/env sh
set -eu

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="$REGION"
export TF_VAR_localstack_endpoint="$ENDPOINT"

instance_id="$(terraform output -json instance_ids | python3 -c 'import json,sys; print(json.load(sys.stdin)["web"])')"

if [ -z "$instance_id" ]; then
  echo "验证失败：instance_ids.web 为空。"
  exit 1
fi

image_id="$(aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
  --region "$REGION" \
  --instance-ids "$instance_id" \
  --query "Reservations[].Instances[].ImageId" \
  --output text)"

instance_type="$(aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
  --region "$REGION" \
  --instance-ids "$instance_id" \
  --query "Reservations[].Instances[].InstanceType" \
  --output text)"

name_tag="$(aws --endpoint-url="$ENDPOINT" ec2 describe-instances \
  --region "$REGION" \
  --instance-ids "$instance_id" \
  --query "Reservations[].Instances[].Tags[?Key=='Name'].Value | [0]" \
  --output text)"

if [ "$image_id" != "ami-0123456789abcdef0" ]; then
  echo "验证失败：实例 AMI 不符合预期，实际为 $image_id。"
  exit 1
fi

if [ "$instance_type" != "t3.micro" ]; then
  echo "验证失败：实例规格不符合预期，实际为 $instance_type。"
  exit 1
fi

if [ "$name_tag" != "tf-lab-45-web" ]; then
  echo "验证失败：Name tag 不符合预期，实际为 $name_tag。"
  exit 1
fi

TF_VAR_ami_rollout_generation=rollout-2 terraform plan -input=false -no-color > replace-check.txt

if ! grep -q "create replacement and then destroy" replace-check.txt; then
  echo "验证失败：AMI rollout 替换计划没有体现 create_before_destroy。"
  exit 1
fi

echo "验证通过：LocalStack EC2 实例存在，AMI/规格/tag 正确，替换计划体现 create_before_destroy。"
