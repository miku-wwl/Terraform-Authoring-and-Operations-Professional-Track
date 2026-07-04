#!/usr/bin/env sh
set -eu

terraform destroy -auto-approve -input=false
rm -f tfplan replace-check.txt

echo "clean ok: lab 47 state was destroyed."
