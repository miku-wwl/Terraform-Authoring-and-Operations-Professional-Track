#!/usr/bin/env sh
set -eu

RESOURCE_ADDRESS="local_file.critical_config"
CONFIG_PATH="output/critical-config.txt"

if terraform state list 2>/dev/null | grep -qx "$RESOURCE_ADDRESS"; then
  terraform state rm "$RESOURCE_ADDRESS" >/dev/null
fi

rm -f "$CONFIG_PATH" tfplan prevent-destroy-check.txt

echo "clean ok: state entry and local protected file were removed if they existed."
