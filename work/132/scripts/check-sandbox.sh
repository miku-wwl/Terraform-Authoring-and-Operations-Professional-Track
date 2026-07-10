#!/usr/bin/env sh
set -eu

expected_endpoint='http://localhost:4566'

[ "${LOCALSTACK_ENDPOINT:-}" = "$expected_endpoint" ] || {
  echo "LOCALSTACK_ENDPOINT must be $expected_endpoint. Refusing to risk a real AWS connection." >&2
  exit 1
}

[ "${TF_VAR_localstack_endpoint:-}" = "$expected_endpoint" ] || {
  echo "TF_VAR_localstack_endpoint must be $expected_endpoint." >&2
  exit 1
}

[ "${AWS_ACCESS_KEY_ID:-}" = 'test' ] && [ "${AWS_SECRET_ACCESS_KEY:-}" = 'test' ] || {
  echo 'Lab 132 requires LocalStack test/test credentials.' >&2
  exit 1
}

command -v docker >/dev/null 2>&1 || {
  echo 'Docker is not available in PATH.' >&2
  exit 1
}

health="$(docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>/dev/null || true)"
[ "$health" = 'healthy' ] || {
  echo "Container localstack-tf-labs is not healthy. Current status: ${health:-missing}" >&2
  exit 1
}

echo 'PASS: LocalStack is healthy, endpoint is local, and credentials are test/test.'
