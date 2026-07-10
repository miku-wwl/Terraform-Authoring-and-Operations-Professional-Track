# Terraform 实操训练 120：Organization、Project 与 Workspace

## 本节主旨

Lab 119 解决“用户怎样进入平台”；Lab 120 继续解决“进入平台后，Terraform 工作负载怎样组织”。

```text
Organization
  ├─ Project: network
  │    ├─ Workspace: network-dev
  │    └─ Workspace: network-prod
  ├─ Project: applications
  │    ├─ Workspace: app-dev
  │    └─ Workspace: app-prod
  └─ Project: security
       ├─ Workspace: security-monitoring
       └─ Workspace: security-hardening
```

## 阶段 1：对象职责

完成 `main.tf` 的 TODO 1：

- Organization：团队、套餐/计费和组织级设置边界。
- Project：组织 workspace/Stack，并帮助划分团队访问范围。
- Workspace：管理一套具体 Terraform 配置的变量、state、runs 和执行设置。

不要把一个 workspace 理解为整个公司的所有 Terraform，也不要把 project 当成 provider 或 module。

## 阶段 2：本地目录与 Remote Workspace

完成 TODO 2。

| 内容 | 本地工作流 | HCP remote workspace |
|---|---|---|
| 配置 | 本地磁盘 | VCS 或 CLI/API 上传 |
| 变量值 | tfvars、CLI、环境变量 | Workspace variables / variable sets |
| State | 本地或自选 remote backend | Workspace-managed state |
| Run history | 终端/CI 自己保存 | Workspace 集中保存 |

HCP Terraform workspace 和 CLI workspace 名称相同，但语义不同：

- HCP workspace 是平台中的基础设施管理单元。
- CLI workspace 是同一 working directory 下多个 state 实例的命名机制。

## 阶段 3：配置来源与 Workflow

完成 TODO 3：

```text
VCS-driven
Git commit/PR 触发 run

CLI-driven
本地 terraform plan/apply 触发 remote run

API-driven
外部自动化上传配置并管理 run
```

原课程主要演示 VCS，但当前官方工作流并不要求所有 workspace 都连接 Git。

## 阶段 4：按职责拆分 Workspace

完成 TODO 4。

通常应根据生命周期、权限、所有权和故障范围拆分 workspace。例如：

- 网络团队管理 network project；
- 应用团队管理 app project；
- 安全团队管理 security project；
- dev 与 prod 使用不同 workspace，隔离 state 和运行权限。

不要仅因为“目录多”就机械拆分，也不要把所有基础设施放进一个巨大 workspace。

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

1. Organization、project、workspace 各自解决什么问题？
2. HCP workspace 和 CLI workspace 是否相同？
3. HCP Terraform 配置是否必须来自 VCS？
4. Remote workspace 中 state 和变量存在哪里？
5. 为什么 network-dev 与 network-prod 通常应该拆成不同 workspace？

## 官方参考

- [HCP Terraform workspaces](https://developer.hashicorp.com/terraform/cloud-docs/workspaces)
- [HCP Terraform projects](https://developer.hashicorp.com/terraform/cloud-docs/projects)
- [HCP Terraform plans and workflows](https://developer.hashicorp.com/terraform/cloud-docs/overview)
