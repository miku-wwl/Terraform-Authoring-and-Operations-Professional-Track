# Terraform 实操训练 126：Sentinel Policy as Code 与策略集建模

## 1. 背景

本目录是 `work/126` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Sentinel 策略、策略集、工作区关联和 enforcement mode 的建模练习。

本节视频的重点是：Sentinel 是 HashiCorp enterprise 产品体系中的 policy as code 框架。在 HCP Terraform / Terraform Cloud 中，策略会被放入 policy set，再把 policy set 关联到 workspace。运行 Terraform plan 之后，平台可以执行 cost estimation 和 policy check。如果 hard mandatory 策略失败，apply 会被阻断，不能被普通用户覆盖。

真实 Sentinel 配置通常需要 HCP Terraform 付费能力或 trial 环境。本 lab 不要求你连接真实 Terraform Cloud，也不要求写真实 AWS 凭证。你只需要基于本地 mock JSON，把 Sentinel 的核心对象关系建模成 Terraform 输出，并通过 `terraform test` 验证理解是否正确。

## 2. 核心主题

- Sentinel：policy as code 框架，用逻辑策略判断 Terraform run 是否允许继续。
- Policy：单条策略，例如 `block EC2 without tags`。
- Policy set：策略集合，用来绑定多个 policy。
- Workspace scope：policy set 可以绑定全部 workspace，也可以绑定指定 workspace。
- Enforcement mode：
  - `hard-mandatory`：失败后不能覆盖，apply 被阻断。
  - `soft-mandatory`：失败后可以由有权限的人覆盖。
  - `advisory`：只记录结果，不阻断。
- HCP Terraform plan：Sentinel 通常属于付费/治理能力；免费计划中可能不可用。
- 防线边界：Sentinel 只检查 Terraform run，无法阻止别人绕过 IaC 在 AWS 控制台手动创建资源；生产环境还需要 AWS Config 等云侧控制。

## 3. 任务目标

请在 `main.tf` 中完成八个 TODO：

1. 用 `jsondecode(file("${path.module}/data/sentinel_policy.json"))` 读取并解析 mock 数据。
2. 从 mock 数据中读取 Sentinel feature 名称。
3. 从 mock 数据中读取是否需要 paid governance plan。
4. 读取 workspace name，并要求值为 `sentinel`。
5. 组装 policy set 对象：
   - name：来自 JSON 的 `policy_set.name`
   - scope：来自 JSON 的 `policy_set.scope`
   - workspaces：来自 JSON 的 `policy_set.workspaces`
6. 组装 policy 对象：
   - name：来自 JSON 的 `policy.name`
   - rule：来自 JSON 的 `policy.rule`
   - enforcement_mode：来自 JSON 的 `policy.enforcement_mode`
   - required_tag_key：来自 JSON 的 `policy.required_tag_key`
7. 从 JSON 读取所有 enforcement modes，并生成 run checks 顺序。
8. 生成 production guardrail layers，顺序必须是：
   - `Terraform run policy check with Sentinel`
   - `Cloud-side drift/resource compliance with AWS Config`

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
- `terraform output feature_name` 显示 `Sentinel`。
- `terraform output requires_paid_plan` 显示 `true`。
- `terraform output workspace_name` 显示 `sentinel`。
- `terraform output policy_set` 显示名为 `sentinel-policy-set` 的策略集，并绑定到 `sentinel` workspace。
- `terraform output policy` 显示 `check-ec2-tags`，规则为 `block_ec2_without_tags`，enforcement mode 为 `hard-mandatory`。
- `terraform output enforcement_modes` 显示 `hard-mandatory`、`soft-mandatory`、`advisory`。
- `terraform output run_checks` 显示 `cost_estimation`、`policy_check`。
- `terraform output production_guardrail_layers` 显示 IaC 侧 Sentinel 和云侧 AWS Config 两层防线。

## 6. 约束

- 不要连接真实 HCP Terraform / Terraform Cloud。
- 不要写真实 AWS access key、secret key 或 HCP Terraform token。
- 不要把 Sentinel 建模成可以检查手动创建资源的万能工具。
- JSON 文件路径必须基于 `path.module` 构造。
- 不要硬编码所有输出绕过 `jsondecode()` 练习。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
