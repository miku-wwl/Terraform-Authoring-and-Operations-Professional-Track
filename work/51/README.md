# 第 51 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- map 字面量：`{ key = value }`
- map 取值：`local.tags["owner"]`
- map 长度：`length(local.tags)`
- map keys：`keys(local.tags)`
- 默认值读取：`lookup(local.tags, "service", "checkout")`
- map 遍历：`for` 表达式

## Windows / PowerShell

```powershell
cd work/51
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
cd work/51
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

- `tags` 是包含三个键值对的 map。
- `owner_tag` 是通过 key 读取出的值。
- `tag_count` 是通过 `length()` 算出的键值对数量。
- `tag_keys` 是通过 `keys()` 得到的 key list。
- `service_name` 是通过 `lookup()` 得到的默认值。
- `tag_labels` 是通过 `for` 表达式生成的 `key=value` list。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
