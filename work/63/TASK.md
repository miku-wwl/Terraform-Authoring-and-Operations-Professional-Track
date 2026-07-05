# Terraform 实操训练 63：嵌套 for 表达式

## 1. 背景

本目录是 `work/63` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 嵌套 `for` 表达式练习。

这个 lab 不需要云资源，只练 Terraform 表达式和复杂集合转换。

## 2. 核心主题

- 嵌套 `for`：在一个 `for` 表达式内部再写一个 `for` 表达式。
- 笛卡尔积：生成 region/app 的所有组合。
- `flatten()`：把嵌套 list 展平成一层 list。
- 对象生成：用嵌套 `for` 生成 object list。
- 嵌套过滤：在内层 `for` 中使用 `if` 子句。
- map 合并：用 `merge([... ]...)` 把多个小 map 合并成一个 flat map。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 用嵌套 `for` 和 `flatten()` 生成 `region_app_labels`。
2. 用嵌套 `for` 和 `flatten()` 生成 `region_app_objects`。
3. 用嵌套 `for` 加 `if app == "worker"` 生成 `worker_region_labels`。
4. 用 `for` 表达式把 `region_app_objects` 转成 `region_app_by_name` map。
5. 用嵌套 `for` 和 `flatten()` 展平 `services_by_region`，生成 `service_labels_by_region`。
6. 用嵌套 `for`、map 表达式和 `merge([... ]...)` 生成 `service_map_by_path`。

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
- `terraform output region_app_labels` 显示四个 region/app 标签。
- `terraform output region_app_objects` 显示四个 region/app 对象。
- `terraform output worker_region_labels` 显示两个 worker 标签。
- `terraform output region_app_by_name` 显示按 name 索引的 region/app map。
- `terraform output service_labels_by_region` 显示三个 region:service 标签。
- `terraform output service_map_by_path` 显示按 region/service 索引的 flat map。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过嵌套 `for` 表达式练习。
- 嵌套 `for` 产生 list(list(...)) 时，要用 `flatten()` 展平。
- 合并多个 map 时使用 `merge([... ]...)`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
