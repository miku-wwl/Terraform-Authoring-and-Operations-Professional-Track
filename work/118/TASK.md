# Terraform 实操训练 118：HCP Terraform Pricing 结构化数据练习

## 1. 背景

本目录是 `work/118` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 HCP Terraform pricing 概念数据处理练习。

本 lab 不会连接 HCP Terraform，不会创建真实云资源，也不会验证实时价格。它把课程中提到的 pricing 概念整理成 `data/pricing.json`，要求你用 Terraform 本地表达式读取、筛选、映射和汇总这些信息。

> 注意：真实产品定价会变化，本练习只使用 mock 数据训练考试概念和 Terraform 表达式写法。

## 2. 核心主题

- HCP Terraform 不一定完全免费，付费能力取决于 plan、使用量和组织需要。
- 常见 plan：`Essentials`、`Standard`、`Premium`。
- 计费关注点：按月、按 managed resource、按使用模式。
- Higher tier features：例如 audit logging、drift detection、policy/security、governance/compliance 等。
- Self-managed / enterprise 场景：例如 air-gapped installation 更偏企业自托管能力。
- Terraform 数据处理：`jsondecode()`、`file()`、`for` 表达式、`contains()`、map 构造、list 过滤。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 用 `jsondecode(file("${path.module}/data/pricing.json"))` 读取并解析 pricing mock 数据。
2. 从解析后的对象中读取 `plans` list。
3. 用 `for` 表达式取出所有 plan name。
4. 构造 `plans_by_name` map，key 为 plan name。
5. 找出不包含 `audit_logging` 的 plan name。
6. 找出支持 `air_gapped_installation` 的 plan name。
7. 从 `billing_models` 中取出所有 billing model name。
8. 构造推荐摘要 `exam_summary`，包含最基础 plan、最高功能 plan、pay-as-you-go 是否存在、air-gapped 是否只在 enterprise 场景。

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
- `terraform output plan_names` 显示 `Essentials`、`Standard`、`Premium`、`Enterprise Self-Managed`。
- `terraform output plans_without_audit_logging` 显示只有 `Essentials`。
- `terraform output air_gapped_plan_names` 显示只有 `Enterprise Self-Managed`。
- `terraform output billing_model_names` 显示 `Pay As You Go`、`Flex`、`Enterprise Self-Managed`。
- `terraform output exam_summary` 能说明考试重点：Essentials 功能最少，Premium 在 HCP 托管 plan 中功能最多，Pay As You Go 存在，Air-gapped 更偏企业自托管。

## 6. 约束

- 不要硬编码输出绕过 `jsondecode()`、`for` 表达式和 `contains()` 练习。
- JSON 文件路径必须基于 `path.module` 构造。
- 真实价格可能变化，不要把本 mock 数据当成实时官方报价。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
