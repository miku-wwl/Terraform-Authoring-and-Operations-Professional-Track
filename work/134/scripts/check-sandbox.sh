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
  echo 'Lab 134 requires LocalStack test/test credentials.' >&2
  exit 1
}

command -v docker >/dev/null 2>&1 || {
  echo 'Docker is not available in PATH.' >&2
  exit 1
}

container_health="$(docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>/dev/null || true)"
[ "$container_health" = 'healthy' ] || {
  echo "Container localstack-tf-labs is not healthy. Current status: ${container_health:-missing}" >&2
  exit 1
}

services_line="$(docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' localstack-tf-labs | grep '^SERVICES=' || true)"
case ",${services_line#SERVICES=}," in
  *,iam,*) ;;
  *)
    echo 'LocalStack IAM service is not enabled. Recreate the container with SERVICES=iam.' >&2
    exit 1
    ;;
esac

echo 'PASS: LocalStack IAM is healthy, endpoint is local, and credentials are test/test.'
