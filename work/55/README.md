# 第 55 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- `count` 创建多个资源实例：`count = length(local.user_names)`
- `count.index` 读取当前实例的数字索引
- 用 `count.index` 从 list 中读取匹配元素：`local.user_names[count.index]`
- 通过资源索引读取实例：`terraform_data.user[0]`
- 遍历 count 创建出的资源实例：`[for user in terraform_data.user : user.output.name]`

## Windows / PowerShell

```powershell
cd work/55
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
cd work/55
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

- `user_names` 是三个用户名组成的 list。
- `resource_count` 表示 `terraform_data.user` 通过 `count` 创建了三个实例。
- 每个资源实例都用 `count.index` 读取了对应的用户名。
- `first_user_name` 是通过 `terraform_data.user[0]` 读取出的第一个实例名称。
- `second_user_index` 是通过 `terraform_data.user[1]` 读取出的第二个实例索引。
- `created_user_names` 是从所有 count 实例中收集出的名称 list。
- `created_user_labels` 是由 `count.index` 和用户名拼接出的标签 list。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
