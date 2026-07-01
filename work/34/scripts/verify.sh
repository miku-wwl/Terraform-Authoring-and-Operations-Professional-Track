#!/usr/bin/env sh
set -eu

ami_id="$(terraform output -raw latest_ami_id)"
ami_name="$(terraform output -raw latest_ami_name)"

if [ -z "$ami_id" ]; then
  echo "验证失败：AMI ID 为空"
  exit 1
fi

case "$ami_name" in
  tf-lab-ubuntu-*) echo "验证通过：最新模拟 AMI 为 $ami_name ($ami_id)" ;;
  *) echo "验证失败：AMI 名称不符合预期：$ami_name"; exit 1 ;;
esac
