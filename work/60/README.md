# 第 60 节做题环境

这个 lab 只使用 Terraform 内置表达式、`csvdecode()`、`file()` 和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。输入数据在 `data/services.csv`。

核心练习：

- 读取文件：`file("${path.module}/data/services.csv")`
- 解码 CSV：`csvdecode(...)`
- CSV 记录读取：`local.services[0].name`
- CSV 字段类型：`csvdecode()` 得到的字段值都是字符串
- 字符串转数字：`tonumber(service.port)`
- CSV 记录过滤：`for` 表达式里的 `if`
- decoded records 转 map：`{ for service in local.services : service.name => service }`

## Windows / PowerShell

```powershell
cd work/60
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
cd work/60
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

- `services` 是从 `data/services.csv` 解码出的三条记录。
- `service_count` 是通过 `length()` 计算出的 CSV 记录数量。
- `first_service_name` 来自第一条 decoded record。
- `service_ports` 是把 CSV 字符串端口转换成数字后的 list。
- `enabled_services` 是通过 `enabled == "true"` 过滤出的服务名 list。
- `service_by_name` 是把 decoded records 转换成按服务名索引的 map。
- `billing_port` 是通过派生 map 读取并转换出的数字端口。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
