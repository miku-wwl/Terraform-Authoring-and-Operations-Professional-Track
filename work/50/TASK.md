# Terraform 实操训练 50：list 数据类型

## 1. 背景

本目录是 `work/50` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform list 表达式练习。

这个 lab 不需要云资源，只练 Terraform 基础数据类型。

## 2. 核心主题

- list 字面量：用 `[]` 定义有顺序的值集合。
- list 索引：用 `[0]` 读取第一个元素。
- list 长度：用 `length()` 计算元素数量。
- list 遍历：用 `for` 表达式把一个 list 转换成另一个 list。

## 3. 任务目标

请在 `main.tf` 中完成四个 TODO：

1. 定义包含三个 region 字符串的 `local.regions`。
2. 用 `local.regions[0]` 得到 `primary_region`。
3. 用 `length(local.regions)` 得到 `region_count`。
4. 用 `for` 表达式生成 `indexed_region_labels`。

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
- `terraform output regions` 显示三个 region。
- `terraform output primary_region` 显示第一个 region。
- `terraform output region_count` 显示 `3`。
- `terraform output indexed_region_labels` 显示三个 `index:region` 标签。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要把 list 改成 map、set 或 object。
- 不要硬编码输出绕过 list 表达式练习。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
