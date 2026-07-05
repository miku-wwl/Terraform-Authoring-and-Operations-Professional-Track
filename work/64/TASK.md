# Terraform 实操训练 64：flatten 与 distinct

## 1. 背景

本目录是 `work/64` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform `flatten()` 与 `distinct()` 表达式练习。

这个 lab 不需要云资源，只练 Terraform 集合数据的展平、去重和二次转换。

## 2. 核心主题

- `flatten()`：把 `list(list(...))` 展平成一层 list。
- `distinct()`：从 list 中删除重复元素，并保留第一次出现的顺序。
- `values()`：把 map 的 value 取出来，形成按 key 排序后的 list。
- 嵌套 `for`：把 map 中的 list 元素展开成标签 list。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 用 `flatten(local.service_groups)` 得到 `all_service_names`。
2. 用 `distinct(local.all_service_names)` 得到 `unique_service_names`。
3. 用 `length(local.unique_service_names)` 得到 `unique_service_count`。
4. 用 `values(local.service_regions)` 得到 `nested_region_lists`。
5. 用 `distinct(flatten(local.nested_region_lists))` 得到 `unique_regions`。
6. 用嵌套 `for` 和 `flatten()` 生成 `service_region_labels`。

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
- `terraform output all_service_names` 显示展平后的六个服务名，包含重复值。
- `terraform output unique_service_names` 显示四个去重后的服务名。
- `terraform output unique_service_count` 显示 `4`。
- `terraform output unique_regions` 显示三个去重后的 region。
- `terraform output service_region_labels` 显示五个 `service:region` 标签。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 `flatten()`、`distinct()` 和 `for` 表达式练习。
- `distinct()` 只能对一层 list 去重；如果数据是嵌套 list，要先用 `flatten()`。
- `values(local.service_regions)` 返回的顺序由 map key 的排序决定，不要假设它保留手写顺序。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
