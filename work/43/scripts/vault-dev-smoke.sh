#!/bin/sh
set -eu
vault server -dev -dev-root-token-id=root >/tmp/vault-dev.log 2>&1 &
pid="$!"
trap 'kill "$pid" >/dev/null 2>&1 || true' EXIT

# TODO 4：连接本地 Vault dev server。
# 提示：dev server 地址是 http://127.0.0.1:8200，root token 是 root。
export VAULT_ADDR="TODO-vault-dev-address"
export VAULT_TOKEN="TODO-vault-dev-token"

# TODO 5：填写要写入和读取的 KV secret 路径。
# 提示：本实验使用 secret/db_creds。
SECRET_PATH="TODO-secret-path"

sleep 3
vault kv put "$SECRET_PATH" username=app password=local-only
vault kv get -format=json "$SECRET_PATH" | grep -q '"username"'
