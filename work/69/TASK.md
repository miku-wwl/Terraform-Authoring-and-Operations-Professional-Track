# Terraform 实操训练 69：CSV 重名规则与 index for_each key

## 1. 背景

本目录是 `work/69` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform CSV 数据处理练习。

这个 lab 会从 `data/sg-02.csv` 读取一组安全组规则数据。和上一类练习不同，这份 CSV 里面的 `name` 字段并不唯一：多条 ingress / egress 规则可能使用同一个名称。

如果你直接写成：

```hcl
{ for rule in local.ingress_rules : rule.name => rule }
```

Terraform 会因为重复 key 报错：`Duplicate object key`。

本 lab 的重点就是：当输入数据没有天然唯一字段时，用 list 的 `index` 作为 `for_each` map 的 key。

## 2. 核心主题

- `file()`：读取当前 module 下的 CSV 文件内容。
- `csvdecode()`：把 CSV 字符串转换成 Terraform object list。
- `for` 过滤：按 `direction` 拆分 ingress 和 egress。
- 双变量 `for`：使用 `for index, rule in ...` 取得 list 下标。
- `for_each` 唯一 key：用 `index => rule` 规避重复名称造成的 duplicate key。
- 用 `terraform_data` 模拟安全组和安全组规则，避免依赖真实 AWS 凭据。

## 3. 任务目标

请在 `main.tf` 中完成五个 TODO：

1. 用 `csvdecode(file(local.rule_file))` 读取并解析 CSV。
2. 从解析后的规则中过滤出 `direction == "ingress"` 的规则。
3. 从解析后的规则中过滤出 `direction == "egress"` 的规则。
4. 为 ingress 规则构造 index-keyed map：`{ for index, rule in local.ingress_rules : index => rule }`。
5. 为 egress 规则构造 index-keyed map：`{ for index, rule in local.egress_rules : index => rule }`。

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
- `terraform output rules` 显示从 CSV 解码出的四条规则。
- `terraform output ingress_rules` 显示两条 ingress 规则。
- `terraform output egress_rules` 显示两条 egress 规则。
- `terraform output ingress_rule_inputs` 的 key 是 `"0"` 和 `"1"`。
- `terraform output egress_rule_inputs` 的 key 也是 `"0"` 和 `"1"`。
- 即使多条规则的 `name` 都是 `web`，也不会再出现 duplicate object key。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 `csvdecode()` 和 `for` 表达式练习。
- CSV 文件路径必须基于 `path.module` 构造。
- 不要使用 `rule.name` 作为 `for_each` map key，因为它在本数据集中不是唯一值。
- 端口字段保持 CSV 解码后的字符串即可，本 lab 的重点不是类型转换。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
