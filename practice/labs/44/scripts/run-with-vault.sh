#!/bin/sh
set -eu
cd /workspace/practice/labs/44
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -var 'vault_addr=http://vault:8200' -var 'vault_token=root' -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve -var 'vault_addr=http://vault:8200' -var 'vault_token=root'
