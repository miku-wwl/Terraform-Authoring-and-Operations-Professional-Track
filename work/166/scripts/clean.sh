#!/usr/bin/env sh
set -eu
rm -rf .terraform .terraform.lock.hcl tfplan terraform.tfstate terraform.tfstate.backup artifacts aws-config
echo 'Cleaned lab files.'
