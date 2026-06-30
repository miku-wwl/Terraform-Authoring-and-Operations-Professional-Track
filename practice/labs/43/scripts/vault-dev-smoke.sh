#!/bin/sh
set -eu
vault server -dev -dev-root-token-id=root >/tmp/vault-dev.log 2>&1 &
pid="$!"
trap 'kill "$pid" >/dev/null 2>&1 || true' EXIT
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
sleep 3
vault kv put secret/db_creds username=app password=local-only
vault kv get -format=json secret/db_creds | grep -q '"username"'
