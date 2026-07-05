# Terraform 实操训练 68：CSV 数据驱动的 ingress/egress rule

## 1. 背景

本目录是 `work/68` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform CSV mock 数据处理练习。

真实环境中，经常会把要放行的 CIDR、端口、协议等规则维护在外部文件中，例如 CSV、JSON 或 YAML。Terraform 代码应从文件动态读取规则，再按条件创建不同类型的资源，而不是把每条规则硬编码在 `.tf` 文件里。

本 lab 会从 `data/sg-01.csv` 读取四条安全组规则，用 `csvdecode()` 转成 Terraform list，然后根据 `direction` 字段拆分成入站规则和出站规则。为了保持本地可运行，本 lab 使用 `terraform_data` 模拟 `aws_vpc_security_group_ingress_rule` 和 `aws_vpc_security_group_egress_rule` 的数据模型。

## 2. 核心主题

- `file()`：读取当前 module 下的 CSV 文件内容。
- `csvdecode()`：把 CSV 字符串转换成 list of object。
- `for` 过滤：根据 `direction == "in"` 或 `direction == "out"` 拆分规则。
- map 构造：用 `{ for rule in ... : rule.name => rule }` 为 `for_each` 准备唯一 key。
- `for_each`：按 CSV 中的规则动态创建 ingress/egress rule 模型。
- `tonumber()`：把 CSV 中读取到的端口字符串转换成 number。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 用 `csvdecode(file("${path.module}/data/sg-01.csv"))` 读取并解析 CSV。
2. 用 `for` 表达式筛选 `direction == "in"` 的入站规则。
3. 用 `for` 表达式筛选 `direction == "out"` 的出站规则。
4. 把入站规则 list 转成以 `name` 为 key 的 map。
5. 把出站规则 list 转成以 `name` 为 key 的 map。
6. 让 `terraform_data.ingress_rule` 使用入站规则 map 作为 `for_each`。
7. 让 `terraform_data.egress_rule` 使用出站规则 map 作为 `for_each`。

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
- `terraform output csv_rules` 显示从 CSV 解码出的四条 rule。
- `terraform output inbound_rule_names` 显示 `rule-01`、`rule-02`。
- `terraform output outbound_rule_names` 显示 `rule-03`、`rule-04`。
- `terraform output ingress_rule_models` 显示两个入站 rule 模型，端口为 number。
- `terraform output egress_rule_models` 显示两个出站 rule 模型，端口为 number。

## 6. 约束

- 不要修改 `practice/` 下的讲义文件。
- 不要硬编码输出绕过 `csvdecode()`、`for` 表达式和 `for_each` 练习。
- CSV 文件路径必须基于 `path.module` 构造。
- 入站规则必须使用 `rule.direction == "in"` 过滤。
- 出站规则必须使用 `rule.direction == "out"` 过滤。
- `for_each` 的 key 必须来自 CSV 中的唯一 `name` 字段。
- `from_port` 和 `to_port` 在 rule model 中必须用 `tonumber()` 转成 number。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
