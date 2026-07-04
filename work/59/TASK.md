# Terraform 实操训练 59：for 表达式基础

## 1. 背景

本目录是 `work/59` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform `for` 表达式基础练习。

这个 lab 不需要云资源，只练 Terraform 表达式和集合转换。

## 2. 核心主题

- list 转换：用 `for` 表达式把一个 list 转成另一个 list。
- index 变量：在 list 遍历中同时读取 index 和 value。
- list 过滤：在 `for` 表达式中使用 `if` 子句。
- map 遍历：同时读取 map 的 key 和 value。
- 生成 map：用 `{ for ... : key => value }` 生成对象/map。
- map 过滤：在生成 map 时使用 `if` 子句过滤元素。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 用 `[for user in local.users : upper(user)]` 生成 `upper_users`。
2. 用带 index 的 `for` 表达式生成 `indexed_users`。
3. 用 `for` 表达式加 `if` 子句生成 `short_users`。
4. 用遍历 map 的 `for` 表达式生成 `service_port_labels`。
5. 用 `{ for user in local.users : user => upper(user) }` 生成 `user_lookup`。
6. 用带 `if` 子句的 map `for` 表达式生成 `public_service_ports`。

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
- `terraform output upper_users` 显示 `ALICE`、`BOB`、`JOHN`。
- `terraform output indexed_users` 显示三个 `index:name` 标签。
- `terraform output short_users` 显示 `bob`、`john`。
- `terraform output service_port_labels` 显示三个 `service:port` 标签。
- `terraform output user_lookup` 显示按用户名索引的大写用户名 map。
- `terraform output public_service_ports` 显示端口小于 `9000` 的服务 map。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 `for` 表达式练习。
- 需要生成 list 的地方使用 `[]` 形式的 `for` 表达式。
- 需要生成 map 的地方使用 `{}` 和 `=>` 形式的 `for` 表达式。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
