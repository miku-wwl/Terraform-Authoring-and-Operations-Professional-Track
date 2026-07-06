# Terraform 实操训练 70：CSV 端口范围处理与 for_each 唯一键

## 1. 背景

本目录是 `work/70` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform CSV 数据处理练习。

这个 lab 会从 `data/sg_03.csv` 读取一组安全组规则数据，用 `csvdecode()` 转成 Terraform list，然后用 `can()`、`regex()`、`split()` 和条件表达式把端口字段处理成 `from_port` / `to_port`。最后再把处理后的 list 转成适合 `for_each` 使用的 map。

CSV 中的规则名称故意不唯一，端口字段也同时包含单端口和端口范围：

- `80-100`：需要拆成 `from_port = 80`、`to_port = 100`。
- `443-445`：需要拆成 `from_port = 443`、`to_port = 445`。
- `8443`：没有范围，需要让 `from_port` 和 `to_port` 都等于 `8443`。

## 2. 核心主题

- `file()`：读取当前 module 下的 CSV 文件内容。
- `csvdecode()`：把 CSV 字符串转换成 Terraform object list。
- `can(regex(...))`：判断某个字符串中是否包含范围分隔符 `-`。
- `split()`：把 `80-100` 这样的字符串拆成两个边界值。
- `tonumber()`：把 CSV 字符串端口转换为 number。
- map 构造：用 `{ for index, rule in ... : "${rule.name}-${index}" => rule }` 给重复名称生成唯一 key。
- `for_each`：使用唯一 key map 驱动多条规则资源。

## 3. 任务目标

请在 `main.tf` 中完成三个 TODO：

1. 用 `csvdecode(file("${path.module}/data/sg_03.csv"))` 读取并解析 CSV。
2. 遍历 CSV 数据，构造 `processed_rules` list；每个对象保留 `name`、`direction`、`protocol`、`cidr_block`，并把 `port` 转成 `from_port` / `to_port`。
3. 用 `for index, rule in local.processed_rules` 构造 `ingress_rules_by_key`，确保每个 `for_each` key 唯一。

完成后运行 `README.md` 中的命令。

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
- `terraform output csv_data` 显示从 CSV 解码出的三条规则。
- `terraform output processed_rules` 显示已经拆分好的 `from_port` / `to_port`。
- `terraform output ingress_rule_keys` 显示 `web-0`、`web-1`、`web-2` 三个唯一 key。
- `terraform output ingress_rules_by_key` 显示适合 `for_each` 使用的 map。
- `terraform output ingress_rule_inputs` 显示模拟资源接收到的三条 ingress rule 输入。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 `csvdecode()`、`split()` 和 `for` 表达式练习。
- CSV 文件路径必须基于 `path.module` 构造。
- 端口字段来自 CSV，所以需要用 `tonumber()` 转换为 number。
- 因为 CSV 中的 `name` 不唯一，`for_each` 的 key 必须加入 index。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
