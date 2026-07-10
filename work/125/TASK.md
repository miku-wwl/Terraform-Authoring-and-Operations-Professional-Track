# Terraform 实操训练 125：HCP Terraform Variable Sets 概念

## 本节主旨

Variable Set 把需要重复配置的变量集中维护，再按组织、项目或 workspace 范围复用：

```text
Organization
  ├─ Organization-owned Variable Set
  │    ├─ Global：所有当前及未来 workspace
  │    └─ 指定 project / workspace / Stack
  └─ Project
       └─ Project-owned Variable Set
            ├─ 整个 project
            └─ 指定 workspace / Stack
```

本 Lab 只考 HCP Terraform 平台概念。你不需要连接 HCP、创建 Variable Set，或用 Terraform 表达式模拟平台行为。

## 阶段 1：Ownership 与 Scope

完成 `main.tf` 的 TODO 1。

| 需求 | 合适选择 |
|---|---|
| 跨多个 project 共享 | Organization-owned Variable Set |
| 只在一个 project 内共享 | Project-owned Variable Set |
| 自动应用整个 organization | Global scope |
| 只应用到指定 workspace | Workspace-scoped |

作用域越宽，维护越集中，但获得变量或凭据的 workspace 也越多。凭据应使用满足需求的最小作用域。

## 阶段 2：两种变量类型

完成 TODO 2。

- Terraform variable：为配置中的 `variable` block / `var.<name>` 提供输入值。
- Environment variable：注入运行进程环境，常用于 provider 设置、Terraform 行为或认证配置。
- HCL checkbox：只适用于 Terraform variable，用来输入 list、map 等 HCL 值。
- Sensitive：两种类型都可以标记。

不要因为二者都出现在 HCP Variables 页面，就把它们当成相同的传值通道。

## 阶段 3：优先级与执行模式

完成 TODO 3。

普通情况下，同类型、同 key 的 workspace-specific variable 会覆盖 Variable Set 中的值，UI 会标记被覆盖项。

同 scope、同 ownership 的 Variable Set 出现同名变量时，HCP Terraform 按 Variable Set 名称的 Unicode 词法顺序判断，而不是“最后编辑的值获胜”。

Priority Variable Set 是管理者显式启用的例外：它可以覆盖更具体作用域中的同名值，包括 CLI run-specific 值。因此 priority 应谨慎使用。

HCP Terraform 不会在 `Local` execution mode 的运行中计算 workspace variables 或 Variable Sets。

## 阶段 4：Sensitive 的真实边界

完成 TODO 4。

- Sensitive 值保存后，在 HCP Terraform UI 和 API 中不可再次读取。
- Sensitive 不等于数据永远不会出现在 Terraform state 或日志中。
- Variable description 不加密，不能写秘密。
- `TF_LOG=TRACE` 可能让环境变量进入日志，调试产物应按敏感数据保护。
- 云 provider 认证优先使用每次 run 的 dynamic credentials，减少长期静态密钥。

因此，Sensitive 是显示与读取保护，不是完整的数据泄露防护边界。

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

1. Variable Set 与 workspace-specific variable 的核心区别是什么？
2. 跨 project 共享变量时应该选择哪种 ownership？
3. Terraform variable 与 environment variable 分别进入哪里？
4. 普通 Variable Set 和 Priority Variable Set 的覆盖行为有何不同？
5. 为什么标记 Sensitive 后仍要保护 state 和 TRACE 日志？

## 官方参考

- [Variables overview and precedence](https://developer.hashicorp.com/terraform/cloud-docs/variables)
- [Manage variables and variable sets](https://developer.hashicorp.com/terraform/cloud-docs/variables/managing-variables)
- [Dynamic provider credentials](https://developer.hashicorp.com/terraform/cloud-docs/dynamic-provider-credentials)
