#!/usr/bin/env sh
set -eu
[ "${LOCALSTACK_ENDPOINT:-}" = http://localhost:4566 ] && [ "${AWS_ACCESS_KEY_ID:-}" = test ] && [ "${AWS_SECRET_ACCESS_KEY:-}" = test ]
[ "$(docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>/dev/null||true)" = healthy ]
docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' localstack-tf-labs|grep -Eq '^SERVICES=(.*,)?ec2(,.*)?$'
