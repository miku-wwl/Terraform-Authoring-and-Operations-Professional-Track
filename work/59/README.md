# 第 59 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- list 遍历：`[for user in local.users : upper(user)]`
- 带 index 的 list 遍历：`[for index, user in local.users : ...]`
- list 过滤：`[for user in local.users : user if ...]`
- map 遍历：`[for name, port in local.service_ports : ...]`
- 从 list 生成 map：`{ for user in local.users : user => upper(user) }`
- map 过滤：`{ for name, port in local.service_ports : name => port if ... }`

## Windows / PowerShell

```powershell
cd work/59
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
cd work/59
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

- `upper_users` 是通过 `for` 表达式转换出的 uppercase list。
- `indexed_users` 是通过带 index 的 `for` 表达式生成的标签 list。
- `short_users` 是通过 `if` 子句过滤出的 list。
- `service_port_labels` 是通过遍历 map 生成的 `service:port` list。
- `user_lookup` 是从 list 生成的 map。
- `public_service_ports` 是通过 `for` 表达式过滤出的 map。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
