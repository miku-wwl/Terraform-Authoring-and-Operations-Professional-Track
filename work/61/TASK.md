# Terraform 实操训练 61：for 表达式进阶

## 1. 背景

本目录是 `work/61` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform `for` 表达式进阶练习。

这个 lab 不需要云资源，只练 Terraform 表达式和复杂集合转换。

## 2. 核心主题

- 过滤 list(object)：在 `for` 表达式中用 `if` 子句筛选对象。
- 生成并过滤 map：使用 `{ for ... : key => value if condition }`。
- grouping mode：使用 `...` 把多个 value 聚合到同一个 key 下。
- 嵌套 `for`：遍历对象列表和对象内部的 list。
- `flatten()`：把嵌套 list 展平成一层 list。
- 派生索引 map：从对象列表生成更方便查询的 map。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 用 `for` 表达式筛选启用服务名，生成 `enabled_service_names`。
2. 用 map `for` 表达式筛选启用服务，生成 `enabled_service_by_name`。
3. 用 grouping mode 按 `tier` 分组服务名，生成 `service_names_by_tier`。
4. 用嵌套 `for` 和 `flatten()` 生成 `service_port_labels`。
5. 用 map `for` 表达式生成启用服务的 `enabled_primary_ports`。
6. 用 `for` 表达式生成启用服务的 `enabled_tier_labels`。

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
- `terraform output enabled_service_names` 显示启用服务名。
- `terraform output enabled_service_by_name` 显示按名称索引的启用服务 map。
- `terraform output service_names_by_tier` 显示按 tier 分组的服务名。
- `terraform output service_port_labels` 显示所有 `service:port` 标签。
- `terraform output enabled_primary_ports` 显示启用服务的首端口 map。
- `terraform output enabled_tier_labels` 显示启用服务的 `tier:name` 标签。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 `for` 表达式练习。
- 需要分组时使用 grouping mode 的 `...`。
- 需要展平嵌套 list 时使用 `flatten()`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
