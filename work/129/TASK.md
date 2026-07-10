# Terraform 实操训练 129：HCP Terraform Workspace Permissions

## 本节主旨

Workspace role 是一组预先组合好的权限，能力逐级增加：

```text
Read
  └─ Plan
       └─ Write
            └─ Admin

Custom：按任务单独组合非 Admin-only 权限
```

本 Lab 只考授权含义。你不需要连接 HCP Terraform、创建真实 Team Access，或用 JSON 模拟权限对象。

## 阶段 1：选择 Workspace Role

完成 `main.tf` 的 TODO 1。

| 角色 | 典型职责 |
|---|---|
| Read | 查看 runs、variables 和 state |
| Plan | 发起 plan，但不能 apply |
| Write | 日常 plan/apply 和 variables/state 维护 |
| Admin | 管理 workspace 设置、Team Access 和删除 workspace |
| Custom | 只组合某个任务真正需要的细粒度权限 |

注意：内置 Read role 包含完整 state read。如果审计员只需看 run history、不应读完整 state，应使用 Custom role，而不是看到“只读”二字就直接选择 Read。

## 阶段 2：Run 与管理权限

完成 TODO 2。

- Read：可以读 runs，不能 plan/apply。
- Plan：可以读和发起 plan，不能 apply。
- Write：可以 plan/apply，但不能修改 workspace settings 或 Team Access。
- Admin：包含所有 workspace permissions，以及 Admin-only 管理能力。

“能提出变更”和“能批准执行变更”应在生产环境中有意识地分离。

## 阶段 3：State 权限

完成 TODO 3。

| State 权限 | 能力 |
|---|---|
| No access | 不访问 state |
| Read outputs only | 读取显式公开的 root outputs |
| Read | 下载完整 state，并隐含 outputs-only |
| Read and write | 读取并创建 state versions |

`read and write` 还用于 Local execution mode，以及 `terraform import`、`terraform taint`、`terraform state` 等 state 维护命令。

完整 state 可能包含资源属性和敏感数据。因此“只需要 subnet ID”通常应考虑 outputs-only，而不是完整 state read。

## 阶段 4：Custom 与敏感权限

完成 TODO 4。

Custom role 可以细分：

- Read/plan/apply runs；
- Variable no access/read/read-write；
- State no access/outputs-only/read/read-write；
- Download Sentinel mocks；
- Lock/unlock workspace；
- Manage Workspace Run Tasks。

Custom 不能授予修改 workspace settings、管理 Team Access 或删除 workspace等 Admin-only 权限。

Sentinel mocks 可能包含未脱敏数据；Run Tasks 会把 run 信息发送给外部服务。这些都不是普通“只读”功能，应限制给可信人员和集成。

## 一个重要安全边界

限制用户通过 UI/API 下载 state，并不等于他绝对无法让 Terraform 读取 state。能够上传恶意配置并发起 run 的用户，可能通过 Terraform 执行间接接触 workspace state。因此设计权限时要同时考虑 configuration upload、run 和 state 能力，而不能只看一个复选框。

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

1. Plan role 能否 apply？
2. Write 与 Admin 的核心差别是什么？
3. Read role 是否只允许读取 outputs？
4. 审计员只看 runs、不看完整 state 时为什么需要 Custom？
5. 为什么 Sentinel mock download 是敏感权限？

## 官方参考

- [Workspace roles and permissions](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/permissions/workspace)
- [Permission model and effective permissions](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/permissions)
- [HCP Terraform security model](https://developer.hashicorp.com/terraform/cloud-docs/architectural-details/security-model)
