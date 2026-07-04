# 第 48 节做题环境

这个 lab 使用 `local_file` 创建一个本地关键配置文件，不需要 LocalStack 或真实云账号。

核心练习：

- `prevent_destroy`
- 防止误删关键资源
- `terraform state rm` 解除 Terraform 管理关系

## Windows / PowerShell

```powershell
cd work/48
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
```

如果中途失败，可以用兜底清理：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\clean.ps1
```

## Linux / Terraform Sandbox

```sh
cd work/48
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
sh scripts/verify.sh
```

如果中途失败，可以用兜底清理：

```sh
sh scripts/clean.sh
```

## 验证重点

`terraform test` 只检查 starter 的基础结构。

真正的行为检查在 `scripts/verify.*`：

- 确认 `output/critical-config.txt` 已经创建。
- 执行 `terraform destroy`，并确认它被 `prevent_destroy` 阻止。
- 执行 `terraform state rm local_file.critical_config`，解除 Terraform 对文件的管理。
- 删除本地文件，确认 state 和文件都清理干净。

注意：`terraform state rm` 不会删除真实对象，它只会把对象从 Terraform state 里移除。
