# Terraform 实操训练 62：for 表达式进阶

## 1. 背景

本目录是 `work/62` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform `for` 表达式进阶练习。

这个 lab 不需要云资源，只练 Terraform 表达式和复杂集合转换。

## 2. 核心主题

- 过滤 list(object)：在 `for` 表达式中用 `if` 子句筛选对象。
- 生成并过滤 map：使用 `{ for ... : key => value if condition }`。
- grouping mode：使用 `...` 把多个 value 聚合到同一个 key 下。
- 嵌套 `for`：遍历对象列表和对象内部的 list。
- `flatten()`：把嵌套 list 展平成一层 list。
- 组合 key：把多个字段拼成稳定 map key。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 用 `for` 表达式筛选生产应用名，生成 `prod_application_names`。
2. 用 map `for` 表达式筛选启用应用，生成 `enabled_applications`。
3. 用 grouping mode 按 `team` 分组应用名，生成 `application_names_by_team`。
4. 用嵌套 `for` 和 `flatten()` 生成 `application_region_labels`。
5. 用 map `for` 表达式生成启用生产应用的 `enabled_prod_primary_regions`。
6. 用组合 key 生成 `application_environment_by_path`。

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
- `terraform output prod_application_names` 显示生产应用名。
- `terraform output enabled_applications` 显示按名称索引的启用应用 map。
- `terraform output application_names_by_team` 显示按 team 分组的应用名。
- `terraform output application_region_labels` 显示所有 `app:region` 标签。
- `terraform output enabled_prod_primary_regions` 显示启用生产应用的首 region map。
- `terraform output application_environment_by_path` 显示按 `team/name` 索引的环境 map。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 `for` 表达式练习。
- 需要分组时使用 grouping mode 的 `...`。
- 需要展平嵌套 list 时使用 `flatten()`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
