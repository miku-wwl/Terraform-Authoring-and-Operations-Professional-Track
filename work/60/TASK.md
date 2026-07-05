# Terraform 实操训练 60：csvdecode 基础

## 1. 背景

本目录是 `work/60` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform `csvdecode()` 表达式练习。

这个 lab 不需要云资源，只练 Terraform 如何读取 CSV 文件并把记录转换成可用的数据结构。

## 2. 核心主题

- `file()`：读取当前模块目录下的数据文件。
- `csvdecode()`：把 CSV 字符串解码成 list(object)。
- CSV 字段类型：CSV 解码后的字段都是字符串。
- list(object) 读取：从 decoded records 中读取字段。
- 类型转换：用 `tonumber()` 把端口字符串转成数字。
- 过滤记录：用 `for` 表达式和 `if` 子句筛选 enabled 服务。
- 派生 map：把 decoded records 转换成按服务名索引的 map。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 用 `csvdecode(file("${path.module}/data/services.csv"))` 得到 `services`。
2. 用 `length(local.services)` 得到 `service_count`。
3. 用 `local.services[0].name` 得到 `first_service_name`。
4. 用 `for` 表达式和 `tonumber(service.port)` 得到 `service_ports`。
5. 用 `for` 表达式加 `if service.enabled == "true"` 得到 `enabled_services`。
6. 用 `{ for service in local.services : service.name => service }` 得到 `service_by_name`。
7. 用 `tonumber(local.service_by_name["billing"].port)` 得到 `billing_port`。

TODO 下方已经写了自验证提示。完成后运行 `README.md` 中的命令。

## 4. 验收方式

基础检查：

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
```

可选观察输出：

```sh
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

## 5. 预期结果

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform output services` 显示三条 CSV 记录。
- `terraform output service_count` 显示 `3`。
- `terraform output first_service_name` 显示 `api`。
- `terraform output service_ports` 显示 `8080`、`9000`、`7070`。
- `terraform output enabled_services` 显示 `api`、`billing`。
- `terraform output service_by_name` 显示按服务名索引的 decoded CSV map。
- `terraform output billing_port` 显示 `7070`。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 `csvdecode()` 练习。
- 不要把 CSV 字段的端口当数字直接使用；先用 `tonumber()` 转换。
- 不要修改 `data/services.csv`，除非题目明确要求。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
