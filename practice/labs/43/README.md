# Lab 43：HashiCorp Vault 基础

本实验先用 Terraform 记录 Vault 接入原则，再用 Vault 官方镜像验证本地 dev server 可以写入和读取 secret。

Terraform 验证：

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

Vault CLI 验证：

```sh
docker run --rm --cap-add IPC_LOCK -v "${PWD}:/workspace" -w /workspace hashicorp/vault:1.18 sh practice/labs/43/scripts/vault-dev-smoke.sh
```
