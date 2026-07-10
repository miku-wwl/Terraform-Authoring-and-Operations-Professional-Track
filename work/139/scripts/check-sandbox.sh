#!/usr/bin/env sh
set -eu
[ "${LOCALSTACK_ENDPOINT:-}" = http://localhost:4566 ] && [ "${AWS_ACCESS_KEY_ID:-}" = test ] && [ "${AWS_SECRET_ACCESS_KEY:-}" = test ] || exit 1
[ "$(docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>/dev/null || true)" = healthy ] || exit 1
docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' localstack-tf-labs | grep -Eq '^SERVICES=(.*,)?ec2(,.*)?$'
echo 'PASS: LocalStack EC2 sandbox is safe.'
