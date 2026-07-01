#!/usr/bin/env sh
set -eu

account_id="$(terraform output -raw account_id)"
region="$(terraform output -raw current_region)"

if [ "$account_id" != "000000000000" ]; then
  echo "验证失败：账号 ID 不是 LocalStack 默认账号，当前为 $account_id"
  exit 1
fi

if [ -z "$region" ]; then
  echo "验证失败：region 输出为空"
  exit 1
fi

echo "验证通过：当前账号 $account_id，区域 $region"
