# 第 53 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- list(object) 字面量：`[{ name = "...", ports = [...] }]`
- 嵌套属性读取：`local.services[0].name`
- 嵌套 list 读取：`local.services[0].ports[0]`
- list(object) 遍历：`[for service in local.services : service.name]`
- 嵌套 list 展平：`flatten([for service in local.services : service.ports])`
- 嵌套 for 表达式：生成 `service:port` 标签
- list(object) 转 map：`{ for service in local.services : service.name => service }`

## Windows / PowerShell

```powershell
cd work/53
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
cd work/53
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

- `services` 是包含 `api` 和 `worker` 的 list(object)。
- `service_count` 是通过 `length()` 计算出的服务数量。
- `first_service_name` 来自第一个 service object 的 `name` 属性。
- `api_primary_port` 来自第一个 service object 内部的 `ports` list。
- `service_names` 是通过 `for` 表达式从 list(object) 中提取出的 name list。
- `all_ports` 是通过 `flatten()` 展平后的端口 list。
- `service_port_labels` 是通过嵌套 `for` 表达式生成的 `service:port` list。
- `service_by_name` 是把 list(object) 转换成以服务名为 key 的 map。
- `worker_tier` 是通过派生 map 继续读取的嵌套属性。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
