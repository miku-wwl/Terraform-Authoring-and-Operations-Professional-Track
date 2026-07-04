# 第 58 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- 条件表达式：`condition ? true_value : false_value`
- 字符串比较条件：`local.environment == "prod"`
- 布尔条件：`local.enable_backups ? "daily" : "none"`
- 数字比较条件：`local.replica_count >= 3`
- 条件选择 list
- 条件选择/合并 map
- `for` 表达式里的 `if` 过滤

## Windows / PowerShell

```powershell
cd work/58
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
cd work/58
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

- `environment` 是 `prod`。
- `enable_backups` 是 `true`。
- `replica_count` 是 `3`。
- `instance_size` 是通过环境条件选择出的 `large`。
- `backup_policy` 是通过布尔条件选择出的 `daily`。
- `high_availability` 是通过数字比较条件选择出的 `true`。
- `selected_zones` 是通过条件表达式选择出的生产 zone list。
- `selected_tags` 是根据生产环境合并出的 tags map。
- `enabled_features` 是通过 `for` 表达式 `if` 条件过滤出的功能列表。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
