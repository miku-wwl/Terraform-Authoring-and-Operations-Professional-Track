#!/usr/bin/env sh
set -eu
if [ "${LOCALSTACK_ENDPOINT:-http://localhost:4566}" != "http://localhost:4566" ]; then
  echo 'Warning: endpoint is not default LocalStack.'
fi
