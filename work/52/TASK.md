# Terraform 实操训练 52：object 数据类型

## 1. 背景

本目录是 `work/52` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform object 表达式练习。

这个 lab 不需要云资源，只练 Terraform 基础数据类型。

## 2. 核心主题

- object 字面量：用 `{}` 定义带固定属性的结构。
- 属性读取：用 `local.service.name` 读取对象属性。
- 混合类型：object 可以同时包含 string、number、bool、map、list。
- 嵌套属性：从 object 内的 `tags` 读取 owner。
- list 属性：从 object 内的 `zones` 读取第一个元素。
- 派生值：用 object 属性拼接字符串。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 定义包含 `name`、`port`、`enabled`、`tags`、`zones` 的 `local.service` object。
2. 用 `local.service.name` 得到 `service_name`。
3. 用 `local.service.port` 得到 `service_port`。
4. 用 `local.service.enabled` 得到 `service_enabled`。
5. 用 `local.service.tags.owner` 得到 `service_owner`。
6. 用 `local.service.zones[0]` 得到 `primary_zone`。
7. 用 service name 和 port 拼接 `service_endpoint`。

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
- `terraform output service` 显示完整 service object。
- `terraform output service_name` 显示 `payments`。
- `terraform output service_port` 显示 `8080`。
- `terraform output service_enabled` 显示 `true`。
- `terraform output service_owner` 显示 `platform`。
- `terraform output primary_zone` 显示 `az-a`。
- `terraform output service_endpoint` 显示 `payments:8080`。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要把 object 拆成多个无关 locals 来绕过 object 练习。
- 不要硬编码输出绕过 object 属性读取。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
