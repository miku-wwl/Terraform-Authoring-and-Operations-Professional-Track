# Terraform 实操训练 71：CSV 与 JSON 数据联表生成规则

## 1. 背景

本目录是 `work/71` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform 数据处理练习。

这个 lab 模拟一个常见场景：安全组规则的主体数据来自 CSV，但 CSV 里没有直接写 CIDR，而是写了一个逻辑名称，例如 `app-1`、`app-2`、`ops`。真正的 CIDR 值保存在 JSON 文件里。你需要用 `csvdecode()`、`jsondecode()` 和 `for` 表达式把两份外部数据关联起来，生成可用于安全组 ingress rule 的结构化数据。

本 lab 不会真的创建 AWS Security Group，而是使用 `terraform_data` 资源模拟按规则创建资源。这样可以在本地直接练习核心 Terraform 表达式，不需要 AWS 凭证。

## 2. 核心主题

- `csvdecode()`：把 CSV 文件解析成 Terraform list object。
- `jsondecode()`：把 JSON 文件解析成 Terraform map。
- 动态索引：用 `local.app_cidr_by_alias[rule.cidr_alias]` 从 JSON map 中取值。
- `for` map 构造：把 CSV rule list 转成按规则名索引的 map。
- `tonumber()`：把 CSV 中的端口字符串转换成 number。
- 名称映射：当 CSV 里的逻辑名和 JSON key 不一致时，用 mapping map 做一次转换。
- `terraform_data` + `for_each`：用本地资源模拟“每条规则一个资源”。

## 3. 输入文件

本 lab 提供三份输入数据：

- `data/sg-71.csv`：安全组规则列表。`cidr_alias` 字段只保存逻辑名称。
- `data/app.json`：第一版 CIDR JSON，key 和 CSV 里的 `cidr_alias` 完全一致。
- `data/app-v2.json`：第二版 CIDR JSON，key 和 CSV 里的 `cidr_alias` 不一致，需要通过 `name_mapping` 转换。

## 4. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 用 `csvdecode(file("${path.module}/data/sg-71.csv"))` 读取并解析 CSV。
2. 用 `jsondecode(file("${path.module}/data/app.json"))` 读取第一版 JSON。
3. 基于 CSV 和第一版 JSON 生成 `direct_ingress_rules` map。
4. 用 `jsondecode(file("${path.module}/data/app-v2.json"))` 读取第二版 JSON。
5. 建立 `name_mapping`，把 CSV 里的 `app-1`、`app-2`、`ops` 映射到第二版 JSON 的 `app`、`database`、`observability`。
6. 基于 CSV、`name_mapping` 和第二版 JSON 生成 `mapped_ingress_rules` map。
7. 从 `mapped_ingress_rules` 生成排序后的 `rule_labels`，格式为 `rule_name:cidr_ipv4:port`。

## 5. 预期规则结构

每条规则最终应包含：

```hcl
{
  direction  = "ingress"
  protocol   = "tcp"
  cidr_alias = "app-1"
  cidr_ipv4  = "10.70.0.0/16"
  from_port  = 443
  to_port    = 443
}
```

## 6. 验收方式

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

## 7. 预期结果

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform output raw_rules` 显示从 CSV 解码出的三条规则。
- `terraform output direct_ingress_rules` 显示基于 `app.json` 计算出的三条规则。
- `terraform output mapped_ingress_rules` 显示基于 `app-v2.json` 和 `name_mapping` 计算出的三条规则。
- `terraform output rule_labels` 显示三条排序后的 `rule_name:cidr_ipv4:port` 标签。
- `terraform_data.ingress_rule` 会按 `mapped_ingress_rules` 的 key 创建三个模拟资源。

## 8. 约束

- 不要修改 `data/` 下的输入数据文件。
- 不要硬编码最终输出绕过 `csvdecode()`、`jsondecode()` 和 `for` 表达式练习。
- 文件路径必须基于 `path.module` 构造。
- CSV 中的 `port` 必须用 `tonumber()` 转换成 number。
- `direct_ingress_rules` 必须通过 `local.app_cidr_by_alias[rule.cidr_alias]` 这类动态索引读取 CIDR。
- `mapped_ingress_rules` 必须先通过 `local.name_mapping[rule.cidr_alias]` 找到第二版 JSON key，再读取 CIDR。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
