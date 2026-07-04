# 第 47 节做题环境

这个 lab 只使用 Terraform 内置的 `terraform_data` 资源，不需要 Docker、LocalStack 或真实云账号。

核心练习：

- `triggers_replace`
- `create_before_destroy`
- 替换计划中的创建/销毁顺序

## Windows / PowerShell

```powershell
cd work/47
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\clean.ps1
```

这里 `terraform plan` / `terraform apply` 使用默认值 `image_version = "v1"`，所以 apply 日志里只会看到 `v1`。
`v2` 只在 `scripts/verify.ps1` 里用于生成替换计划，不会真的 apply。

## Linux / Terraform Sandbox

```sh
cd work/47
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
sh scripts/verify.sh
sh scripts/clean.sh
```

这里 `terraform plan` / `terraform apply` 使用默认值 `image_version = "v1"`，所以 apply 日志里只会看到 `v1`。
`v2` 只在 `scripts/verify.sh` 里用于生成替换计划，不会真的 apply。

## 验证重点

`terraform test` 只检查 starter 的基础结构。

真正的行为检查在 `scripts/verify.*`：

- 先假设你已经 apply 了默认的 `image_version = "v1"`。
- 再由验证脚本执行 `terraform plan -var="image_version=v2"`。
- 这个 `v2` plan 只用于观察 replacement，不会执行 `terraform apply`。
- 验证脚本会把完整替换计划写入 `replace-check.txt`。
- 如果 `triggers_replace` 写对，plan 会显示 release object 必须替换。
- 如果 `create_before_destroy` 写对，plan 会显示先创建替代对象，再销毁旧对象。

想手动查看 `v2` 计划，可以在 apply `v1` 之后执行：

```sh
terraform plan -var="image_version=v2" -input=false -no-color
```
