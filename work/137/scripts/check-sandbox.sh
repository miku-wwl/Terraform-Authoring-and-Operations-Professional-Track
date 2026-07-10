#!/usr/bin/env sh
set -eu
expected_endpoint='http://localhost:4566'
[ "${LOCALSTACK_ENDPOINT:-}" = "$expected_endpoint" ] || { echo 'Invalid LocalStack endpoint.' >&2; exit 1; }
[ "${TF_VAR_localstack_endpoint:-}" = "$expected_endpoint" ] || { echo 'Invalid Terraform endpoint.' >&2; exit 1; }
[ "${AWS_ACCESS_KEY_ID:-}" = test ] && [ "${AWS_SECRET_ACCESS_KEY:-}" = test ] || { echo 'Lab 137 requires test/test credentials.' >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo 'Docker is unavailable.' >&2; exit 1; }
container_health="$(docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>/dev/null || true)"
[ "$container_health" = healthy ] || { echo "LocalStack is unhealthy: ${container_health:-missing}" >&2; exit 1; }
services_line="$(docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' localstack-tf-labs | grep '^SERVICES=' || true)"
case ",${services_line#SERVICES=}," in *,iam,*) ;; *) echo 'Recreate LocalStack with SERVICES=iam.' >&2; exit 1 ;; esac
echo 'PASS: LocalStack IAM is healthy, endpoint is local, and credentials are test/test.'
