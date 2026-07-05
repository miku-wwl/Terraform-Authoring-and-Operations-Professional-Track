# 第 61 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- list(object) 过滤：`[for service in local.services : service.name if service.enabled]`
- 生成 map 并过滤：`{ for service in local.services : service.name => service if service.enabled }`
- grouping mode：`{ for service in local.services : service.tier => service.name... }`
- 嵌套 `for` 表达式
- `flatten()` 展平嵌套 list
- 从对象列表派生索引 map

## Windows / PowerShell

```powershell
cd work/61
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
cd work/61
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

- `enabled_service_names` 是通过 `if` 子句过滤出的服务名 list。
- `enabled_service_by_name` 是通过 `for` 表达式生成并过滤出的 map。
- `service_names_by_tier` 是通过 grouping mode 按 tier 分组出的 map(list)。
- `service_port_labels` 是通过嵌套 `for` 和 `flatten()` 生成的扁平标签 list。
- `enabled_primary_ports` 是从启用服务派生出的 name => first port map。
- `enabled_tier_labels` 是只针对启用服务生成的 tier:name list。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
