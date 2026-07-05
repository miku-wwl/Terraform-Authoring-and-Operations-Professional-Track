# 第 63 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- 嵌套 `for` 表达式生成笛卡尔积
- `flatten()` 展平嵌套 list
- 嵌套 `for` 生成对象 list
- 嵌套 `for` 搭配 `if` 过滤
- 从嵌套 for 结果派生 map
- `merge([... ]...)` 合并多个 map

## Windows / PowerShell

```powershell
cd work/63
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
cd work/63
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

- `region_app_labels` 是所有 region/app 组合的扁平 list。
- `region_app_objects` 是所有 region/app 组合的对象 list。
- `worker_region_labels` 是用嵌套 `for` 和 `if` 筛选出的 worker 标签。
- `region_app_by_name` 是从对象 list 派生出的 map。
- `service_labels_by_region` 是从 map(list) 展平出的标签 list。
- `service_map_by_path` 是从 map(list) 展平并合并出的 map。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
