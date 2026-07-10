# Terraform 实操训练 117：HCP Terraform 概览

## 本节主旨

HCP Terraform 是帮助团队集中运行和治理 Terraform 的平台。旧资料中的 Terraform Cloud 通常指它的旧名称。

它解决的不是“怎样写 resource block”，而是多人共同使用 Terraform 时的运行环境、state、审计、审批、变量、权限和策略问题。

```text
本地 CLI 工作流
代码 + 变量 + state + 执行记录
经常分散在工程师电脑或团队自建系统中

HCP Terraform 工作流
workspace 集中关联配置、变量、state、run 历史和权限
remote run 提供一致的执行环境
```

## 阶段 1：理解产品定位

完成 `main.tf` 的 TODO 1，重点排除四个误解：

- HCP Terraform 不替代 Terraform 语言。
- Terraform CLI 仍然有价值，并且可以触发 remote run。
- HCP Terraform workspace 不等于 CLI workspace。
- VCS integration 很常用，但不是硬性要求，也可以通过 CLI/API 上传配置。

完成后运行：

```powershell
terraform plan -input=false -no-color
```

观察 `platform_facts`。

## 阶段 2：理解典型 Run Workflow

完成 TODO 2。本场景假设：

- VCS commit 触发 run；
- 已启用 cost estimation；
- 已配置强制 policy checks；
- `auto_apply = false`。

因此示例顺序为：

```text
VCS change
→ plan
→ cost estimation
→ policy check
→ manual approval
→ apply
```

这不是所有 run 永远固定的阶段。是否出现成本估算、策略检查和人工确认，取决于套餐、配置、策略和 run 类型。

## 阶段 3：把团队问题映射到平台能力

完成 TODO 3：

| 团队问题 | 对应能力 |
|---|---|
| 几天后追查谁 plan/apply | Run history |
| 多人共享并保留 state 版本 | Remote state |
| 禁止无标签资源进入 apply | Policy enforcement |
| 团队共享内部 module | Private registry |
| 隐藏变量值 | Sensitive variables |
| Git commit 自动触发 run | VCS integration |

敏感变量能降低直接暴露风险，但真实云凭证仍应优先考虑短期、动态的认证方式，而不是长期 access key。

## 阶段 4：Policy 与审批判断

完成 TODO 4，区分两个独立条件：

1. 强制策略失败：run 不能进入 apply。
2. `auto_apply = false`：如果 run 通过必要检查，apply 前仍需要人工确认。

“需要人工确认”不代表可以绕过失败的强制策略。

## 最终验收

```powershell
terraform fmt
terraform validate
terraform test
```

预期：

```text
Success! 1 passed, 0 failed.
```

## 你现在应该能回答

1. HCP Terraform 是否取代 Terraform CLI？
2. HCP Terraform workspace 和 CLI workspace 是否相同？
3. VCS 是否是唯一的配置来源？
4. Run history、remote state、private registry 分别解决什么问题？
5. 强制策略失败和 `auto_apply = false` 分别会造成什么结果？
