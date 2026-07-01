#!/usr/bin/env sh
set -eu
terraform output >/dev/null
echo 'PASS: terraform outputs exist.'
