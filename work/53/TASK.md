# Terraform 实操训练 53：嵌套类型

## 1. 背景

本目录是 `work/53` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 嵌套类型表达式练习。

这个 lab 不需要云资源，只练 Terraform 基础数据类型和表达式组合。

## 2. 核心主题

- list(object)：用 list 保存多个结构相同的服务对象。
- 嵌套属性读取：从 list 中取 object，再读取 object 属性。
- 嵌套 list 读取：从 object 内部的 list 中读取端口。
- list(object) 遍历：用 `for` 表达式提取服务名。
- 嵌套 list 展平：用 `flatten()` 合并多个端口 list。
- 嵌套 for 表达式：从 service 和 port 两层结构生成标签。
- 派生 map：把 list(object) 转换成按服务名索引的 map。

## 3. 任务目标

请在 `main.tf` 中完成九个 TODO：

1. 定义包含 `api`、`worker` 两个对象的 `local.services` list(object)。
2. 用 `length(local.services)` 得到 `service_count`。
3. 用 `local.services[0].name` 得到 `first_service_name`。
4. 用 `local.services[0].ports[0]` 得到 `api_primary_port`。
5. 用 `for` 表达式生成 `service_names`。
6. 用 `flatten()` 展平所有 `ports`，生成 `all_ports`。
7. 用嵌套 `for` 表达式生成 `service_port_labels`。
8. 用 `for` 表达式把 `services` 转成 `service_by_name` map。
9. 用 `local.service_by_name["worker"].tags.tier` 得到 `worker_tier`。

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
- `terraform output services` 显示两个嵌套 service object。
- `terraform output service_count` 显示 `2`。
- `terraform output first_service_name` 显示 `api`。
- `terraform output api_primary_port` 显示 `8080`。
- `terraform output service_names` 显示 `api`、`worker`。
- `terraform output all_ports` 显示 `8080`、`9090`、`9000`。
- `terraform output service_port_labels` 显示三个 `service:port` 标签。
- `terraform output worker_tier` 显示 `backend`。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要把嵌套结构拆成多个互不相关的 locals 来绕过嵌套类型练习。
- 不要硬编码输出绕过 list(object)、嵌套属性读取和 `for` 表达式练习。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
