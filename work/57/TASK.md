# Terraform 实操训练 57：for_each 基础

## 1. 背景

本目录是 `work/57` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform `for_each` 基础练习。

这个 lab 不需要云资源，只使用 `terraform_data` 模拟通过 map 创建多个资源实例。

## 2. 核心主题

- `for_each`：根据 map 或 set 创建多个资源实例。
- `each.key`：读取当前 map entry 的 key。
- `each.value`：读取当前 map entry 的 value。
- 资源实例 key：用 `terraform_data.service["api"]` 读取 for_each 创建出的某个实例。
- 资源实例遍历：用 `for` 表达式收集所有 for_each 实例的输出值。

## 3. 任务目标

请在 `main.tf` 中完成八个 TODO：

1. 定义包含 `api`、`worker`、`web` 的 `local.service_files` map。
2. 用 `for_each = local.service_files` 创建对应数量的 `terraform_data.service` 实例。
3. 用 `each.key` 为每个实例设置 `name`。
4. 用 `each.value` 为每个实例设置 `content`。
5. 用 `each.key` 和 `each.value` 拼接 `label`。
6. 用 `keys(local.service_files)` 得到 `service_keys`。
7. 用 `for` 表达式从所有 `terraform_data.service` 实例中收集 `service_contents`。
8. 用 `for` 表达式从所有 `terraform_data.service` 实例中构造 `service_labels_by_name`。

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
- `terraform output service_files` 显示三个服务。
- `terraform output service_count` 显示 `3`。
- `terraform output resource_count` 显示 `3`。
- `terraform output service_keys` 显示排序后的服务名。
- `terraform output api_content` 显示 `api service`。
- `terraform output worker_name` 显示 `worker`。
- `terraform output service_contents` 显示三个服务内容。
- `terraform output service_labels_by_name` 显示以服务名为 key 的标签 map。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要把 `for_each` 改成 `count`；本节目标是理解 `each.key` 和 `each.value`。
- 不要硬编码输出绕过 `for_each` 创建出的资源实例。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
