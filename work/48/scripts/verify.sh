#!/usr/bin/env sh
set -eu

RESOURCE_ADDRESS="local_file.critical_config"
CONFIG_PATH="$(terraform output -raw critical_config_path)"

if [ ! -f "$CONFIG_PATH" ]; then
  echo "verify failed: expected protected file at $CONFIG_PATH." >&2
  exit 1
fi

set +e
terraform destroy -auto-approve -input=false -no-color >prevent-destroy-check.txt 2>&1
DESTROY_EXIT="$?"
set -e

if [ "$DESTROY_EXIT" -eq 0 ]; then
  echo "verify failed: terraform destroy succeeded. prevent_destroy should block it." >&2
  exit 1
fi

if ! grep -Eq "prevent_destroy|cannot be destroyed|Instance cannot be destroyed" prevent-destroy-check.txt; then
  echo "verify failed: destroy failed, but not because of prevent_destroy. See prevent-destroy-check.txt." >&2
  exit 1
fi

terraform state rm "$RESOURCE_ADDRESS" >/dev/null
rm -f "$CONFIG_PATH"

if [ -f "$CONFIG_PATH" ]; then
  echo "verify failed: protected file still exists after state cleanup." >&2
  exit 1
fi

if terraform state list 2>/dev/null | grep -qx "$RESOURCE_ADDRESS"; then
  echo "verify failed: $RESOURCE_ADDRESS is still in state after terraform state rm." >&2
  exit 1
fi

echo "verify passed: prevent_destroy blocked destroy, then state rm detached the file and cleanup removed it."
