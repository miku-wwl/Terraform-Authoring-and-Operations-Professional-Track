# 第 54 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- map(object) 字面量：`{ dev = { ... }, prod = { ... } }`
- 嵌套 object 属性读取：`local.environments.prod.replicas`
- 嵌套 list 读取：`local.environments.prod.zones[0]`
- 嵌套 map/object 读取：`local.environments.prod.tags.owner`
- map keys：`keys(local.environments)`
- map(object) 遍历：`for` 表达式

## Windows / PowerShell

```powershell
cd work/54
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
cd work/54
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

- `environments` 是包含 `dev` 和 `prod` 的 map(object)。
- `environment_count` 是通过 `length()` 计算出的环境数量。
- `prod_replicas` 来自 `prod` 环境对象里的嵌套数字属性。
- `prod_region` 来自 `prod` 环境对象里的嵌套字符串属性。
- `prod_primary_zone` 来自 `prod` 环境对象内部的 `zones` list。
- `prod_owner` 来自 `prod` 环境对象内部的 `tags` map/object。
- `environment_names` 是通过 `keys()` 得到的环境名 list。
- `environment_region_labels` 是通过 `for` 表达式生成的 `environment:region` list。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
