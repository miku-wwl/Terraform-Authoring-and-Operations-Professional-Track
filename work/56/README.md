# 第 56 节做题环境

这个 lab 只使用 Terraform 内置表达式和 `terraform_data`，不需要 Docker、LocalStack 或真实云账号。

你要先完成 `main.tf` 里的 TODO，再执行验收命令。

核心练习：

- map 字面量：`{ api = 8080, worker = 9000 }`
- map 按 key 取值：`local.service_ports["api"]`
- map 长度：`length(local.service_ports)`
- map keys：`keys(local.service_ports)`
- map values：`values(local.service_ports)`
- 默认值读取：`lookup(local.service_ports, "admin", 7000)`
- map 遍历：`for` 表达式

## Windows / PowerShell

```powershell
cd work/56
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
cd work/56
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

- `service_ports` 是包含三个服务端口的 map。
- `api_port` 是通过 key 读取出的端口值。
- `service_count` 是通过 `length()` 计算出的 map 键值对数量。
- `service_names` 是通过 `keys()` 得到的 service name list。
- `port_numbers` 是通过 `values()` 得到的 port number list。
- `admin_port` 是通过 `lookup()` 得到的默认端口。
- `service_port_labels` 是通过 `for` 表达式生成的 `service:port` list。

starter 状态下测试会失败；按 TODO hint 完成后应返回 `1 passed, 0 failed`。
