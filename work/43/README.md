# 第 43 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/43/ 中的参考实现。

本节重点练习 Vault dev server 的本地 smoke test、KV secret 路径约定，以及 Terraform 读取 secret 后可能进入 state 的风险。Terraform 配置只记录 metadata；secret 原文通过 Vault CLI 写入和读取。

Terraform 练习容器：

```powershell
docker run -it --rm --name tf-work-43 `
  -v "${PWD}/work/43:/workspace" `
  -w /workspace `
  --entrypoint sh `
  hashicorp/terraform:1.11
```

容器内执行：

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

Vault CLI smoke test 会启动本地 dev server，写入并读取 `secret/db_creds`：

```powershell
docker run --rm --cap-add IPC_LOCK `
  -v "${PWD}/work/43:/workspace" `
  -w /workspace `
  hashicorp/vault:1.18 `
  sh scripts/vault-dev-smoke.sh
```
