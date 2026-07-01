#!/usr/bin/env sh
set -eu
if [ "${LOCALSTACK_ENDPOINT:-http://localhost:4566}" != "http://localhost:4566" ]; then
  echo '警告：当前 endpoint 不是默认 LocalStack 地址，请确认没有连接真实 AWS。'
fi
