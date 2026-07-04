# 第 57 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- `for_each` 基于 map 创建多个资源实例：`for_each = local.service_files`
- `each.key` 读取当前 map entry 的 key
- `each.value` 读取当前 map entry 的 value
- 通过 key 读取资源实例：`terraform_data.service["api"]`
- 遍历 for_each 创建出的资源实例：`for` 表达式
- 从资源实例集合派生 map：`{ for name, service in terraform_data.service : name => ... }`

## Windows / PowerShell

```powershell
cd work/57
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
cd work/57
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

- `service_files` 是包含三个服务的 map。
- `terraform_data.service` 通过 `for_each` 创建了三个实例。
- 每个实例都通过 `each.key` 保存自己的服务名。
- 每个实例都通过 `each.value` 保存自己的服务内容。
- `api_content` 是通过 `terraform_data.service["api"]` 读取出的值。
- `service_contents` 是从所有 for_each 实例中收集出的内容 list。
- `service_labels_by_name` 是从所有 for_each 实例中派生出的标签 map。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
