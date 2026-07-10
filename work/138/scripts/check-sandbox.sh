#!/usr/bin/env sh
set -eu
[ "${LOCALSTACK_ENDPOINT:-}" = http://localhost:4566 ] && [ "${TF_VAR_localstack_endpoint:-}" = http://localhost:4566 ] || { echo 'Invalid endpoint.' >&2; exit 1; }
[ "${AWS_ACCESS_KEY_ID:-}" = test ] && [ "${AWS_SECRET_ACCESS_KEY:-}" = test ] || { echo 'Lab 138 requires test/test credentials.' >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo 'Docker unavailable.' >&2; exit 1; }
[ "$(docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>/dev/null || true)" = healthy ] || { echo 'LocalStack unhealthy.' >&2; exit 1; }
services_line="$(docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' localstack-tf-labs | grep '^SERVICES=' || true)"
case ",${services_line#SERVICES=}," in *,iam,*) ;; *) echo 'Recreate with SERVICES=iam.' >&2; exit 1 ;; esac
echo 'PASS: LocalStack IAM is healthy, endpoint is local, and credentials are test/test.'
