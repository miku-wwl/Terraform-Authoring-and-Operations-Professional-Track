# 第 52 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- object 字面量：`{ name = "...", port = 8080 }`
- object 属性读取：`local.service.name`
- object 中的布尔值和数字值
- object 中的嵌套 map/object：`local.service.tags.owner`
- object 中的 list：`local.service.zones[0]`
- 基于 object 属性拼接派生值

## Windows / PowerShell

```powershell
cd work/52
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

## Linux / Terraform Sandbox

```sh
cd work/52
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

## 验证重点

`terraform test` 会检查：

- `service` 是包含多种属性类型的 object。
- `service_name`、`service_port`、`service_enabled` 都来自 object 属性。
- `service_owner` 来自嵌套属性。
- `primary_zone` 来自 object 内部的 list。
- `service_endpoint` 是用 object 属性拼接出的字符串。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
