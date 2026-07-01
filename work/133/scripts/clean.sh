#!/usr/bin/env sh
set -eu
rm -rf .terraform .terraform.lock.hcl tfplan terraform.tfstate terraform.tfstate.backup
echo '已清理 Terraform 本地缓存和状态文件。'
