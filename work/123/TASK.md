# Terraform 实操训练 123：CLI-driven Workflow 概念

## 本节主旨

CLI-driven workflow 保留本地 Terraform CLI 使用习惯，但把运行、state 和协作记录交给 HCP Terraform：

```text
本地配置目录
  └─ 本地执行 terraform plan/apply/destroy
           │
           │ 上传配置、发起 Run
           ▼
HCP Terraform Workspace
  ├─ Remote execution
  ├─ Remote state
  ├─ Variables / credentials
  ├─ Run history
  └─ Policies / permissions
```

## 阶段 1：Workflow 选择

完成 `main.tf` 的 TODO 1：

| 场景 | 推荐 workflow |
|---|---|
| 本地 CLI 发起远端 run | CLI-driven |
| Git PR 是 source of truth | VCS-driven |
| 内部平台通过 API 上传配置 | API-driven |

CLI-driven 不要求代码必须先提交 Git。它适合保留本地 CLI 入口，但团队仍应自行管理代码版本和审批流程。

## 阶段 2：三种认证职责

完成 TODO 2：

- `cloud` block：关联本地配置目录与 HCP organization/workspace。
- `terraform login`：本地 Terraform CLI 登录 HCP Terraform。
- Provider authentication：HCP 远端 run 登录 AWS/Azure/GCP。

这三者不能互相替代。完成 `terraform login` 不代表 AWS provider 已经获得权限。

远端 provider 认证优先使用 OIDC dynamic credentials，为每次 run 获取短期、最小权限凭证。

## 阶段 3：本地发起、远端执行

完成 TODO 3：

- `terraform plan`：上传本地配置并启动远端 speculative plan。
- `terraform apply`：对未连接 VCS 的 workspace 启动远端 standard run。
- `terraform destroy`：启动远端 destroy run。
- 远端日志会流回本地终端。
- State 保存于 HCP Terraform workspace。

因此“从本地输入命令”不等于“在本地执行 provider 操作”。

## 阶段 4：Workspace Readiness

完成 TODO 4。

`terraform init` 可以根据 `cloud` block 创建不存在的 workspace，但新 workspace 通常仍需要检查：

- Terraform variables 和 environment variables；
- Dynamic provider credentials；
- Terraform version；
- Team permissions；
- execution mode、policy 和 apply 设置。

对象创建成功不代表已经适合生产 apply。

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

1. CLI-driven 是否要求 Git repository？
2. `terraform login` 是否负责 AWS provider 认证？
3. 本地运行 `terraform plan` 时，真正的 plan 在哪里执行？
4. CLI-driven workspace 的 state 保存在哪里？
5. 新建 workspace 为什么不能直接用于生产 apply？

## 官方参考

- [CLI-driven remote run workflow](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/run/cli)
- [Terraform CLI integration](https://developer.hashicorp.com/terraform/cli/cloud)
- [Dynamic provider credentials](https://developer.hashicorp.com/terraform/cloud-docs/dynamic-provider-credentials)
