# Terraform 实操训练 58：条件表达式

## 1. 背景

本目录是 `work/58` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 条件表达式练习。

这个 lab 不需要云资源，只练 Terraform 表达式和数据类型组合。

## 2. 核心主题

- 条件表达式：用 `condition ? true_value : false_value` 在两个值之间选择。
- 字符串比较：根据 `local.environment == "prod"` 选择值。
- 布尔条件：根据 `true` 或 `false` 选择值。
- 数字比较：根据 `local.replica_count >= 3` 选择值。
- 条件选择集合：用条件表达式选择 list 或 map。
- 条件过滤：在 `for` 表达式中使用 `if` 子句过滤元素。

## 3. 任务目标

请在 `main.tf` 中完成九个 TODO：

1. 将 `environment` 设置为 `prod`。
2. 将 `enable_backups` 设置为 `true`。
3. 将 `replica_count` 设置为 `3`。
4. 用 `local.environment == "prod" ? "large" : "small"` 得到 `instance_size`。
5. 用 `local.enable_backups ? "daily" : "none"` 得到 `backup_policy`。
6. 用 `local.replica_count >= 3 ? true : false` 得到 `high_availability`。
7. 根据环境选择 `selected_zones`。
8. 根据环境选择并合并 `selected_tags`。
9. 用 `for` 表达式里的 `if` 子句生成 `enabled_features`。

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
- `terraform output environment` 显示 `prod`。
- `terraform output instance_size` 显示 `large`。
- `terraform output backup_policy` 显示 `daily`。
- `terraform output high_availability` 显示 `true`。
- `terraform output selected_zones` 显示 `az-a`、`az-b`。
- `terraform output selected_tags` 显示带 `critical = "true"` 的 tags。
- `terraform output enabled_features` 显示 `metrics`、`tracing`。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要用硬编码输出绕过条件表达式练习。
- 条件表达式两边的结果类型要保持兼容。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
