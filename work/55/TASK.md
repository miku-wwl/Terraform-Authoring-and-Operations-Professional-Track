# Terraform 实操训练 55：count 的索引挑战

## 1. 背景

本目录是 `work/55` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform `count` 和索引表达式练习。

这个 lab 不需要云资源，只使用 `terraform_data` 模拟可重复创建的资源实例。

## 2. 核心主题

- `count`：根据一个数字创建多个资源实例。
- `count.index`：读取当前资源实例的零基索引。
- list 索引：用 `count.index` 从 list 中读取当前实例对应的值。
- 资源实例索引：用 `terraform_data.user[0]` 读取 count 创建出的某个实例。
- 资源实例遍历：用 `for` 表达式收集所有 count 实例的输出值。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 定义包含 `user-01`、`user-02`、`user-03` 的 `local.user_names` list。
2. 用 `count = length(local.user_names)` 创建对应数量的 `terraform_data.user` 实例。
3. 用 `local.user_names[count.index]` 为每个实例设置匹配的 `name`。
4. 用 `count.index` 为每个实例设置 `index`。
5. 用 `count.index` 和当前用户名拼接 `label`。
6. 用 `for` 表达式从所有 `terraform_data.user` 实例中收集 `created_user_names`。
7. 用 `for` 表达式从所有 `terraform_data.user` 实例中收集 `created_user_labels`。

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
- `terraform output user_names` 显示三个用户名。
- `terraform output user_count` 显示 `3`。
- `terraform output resource_count` 显示 `3`。
- `terraform output first_user_name` 显示 `user-01`。
- `terraform output second_user_index` 显示 `1`。
- `terraform output created_user_names` 显示三个 count 实例的用户名。
- `terraform output created_user_labels` 显示三个带索引的用户标签。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要把 `count` 改成 `for_each`；本节目标是理解 `count.index`。
- 不要硬编码输出绕过 `count` 创建出的资源实例。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
