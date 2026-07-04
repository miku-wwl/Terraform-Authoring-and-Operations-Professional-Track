# 第 50 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- list 字面量：`["a", "b", "c"]`
- list 索引：`local.regions[0]`
- list 长度：`length(local.regions)`
- list 遍历：`for` 表达式

## Windows / PowerShell

```powershell
cd work/50
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
cd work/50
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

- `regions` 是三个字符串组成的 list。
- `primary_region` 是通过 `[0]` 取出的第一个元素。
- `region_count` 是通过 `length()` 算出的数量。
- `indexed_region_labels` 是通过 `for` 表达式生成的 `index:region` list。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
