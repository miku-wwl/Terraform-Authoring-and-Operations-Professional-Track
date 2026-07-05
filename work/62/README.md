# 第 62 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack、真实云账号或本地文件 provider。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- list(object) 过滤：`[for app in local.applications : app.name if ...]`
- 生成并过滤 map：`{ for app in local.applications : app.name => app if app.enabled }`
- grouping mode：`{ for app in local.applications : app.team => app.name... }`
- 嵌套 `for` 表达式遍历应用和 regions
- `flatten()` 展平嵌套 list
- 组合 key：`"${app.team}/${app.name}"`

## Windows / PowerShell

```powershell
cd work/62
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
cd work/62
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

- `prod_application_names` 是通过环境过滤出的生产应用名。
- `enabled_applications` 是通过 `for` 表达式生成并过滤出的 map。
- `application_names_by_team` 是通过 grouping mode 按 team 分组出的 map(list)。
- `application_region_labels` 是通过嵌套 `for` 和 `flatten()` 生成的扁平标签 list。
- `enabled_prod_primary_regions` 是从启用生产应用派生出的 name => primary region map。
- `application_environment_by_path` 是用组合 key 派生出的 map。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
