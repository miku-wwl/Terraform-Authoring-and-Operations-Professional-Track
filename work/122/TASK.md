# Terraform 实操训练 122：VCS Workspace 与安全认证

## 本节主旨

VCS-driven workflow 把 Git 仓库作为 Terraform 配置的 source of truth：

```text
Pull Request
→ Speculative Plan
→ 只用于预览和检查，不能直接 Apply

Merge / Push to main
→ Standard Plan
→ Policy / Cost 等检查
→ Manual confirmation（本场景）
→ Apply 或 Discard
```

## 阶段 1：连接 Repository

完成 `main.tf` 的 TODO 1。

一个 VCS workspace 通常需要考虑：

- Repository：连接哪个仓库；
- Branch：监控哪个分支，留空时可能使用默认分支；
- Working directory：Terraform root module 位于仓库哪个目录；
- Trigger patterns：哪些路径变化才触发 run；
- Speculative plans：PR 是否自动 plan；
- Apply method：manual 或 auto apply。

Monorepo 不建议所有文件变化都触发所有 workspace，应配置 working directory 和路径过滤。

## 阶段 2：PR、Push、Apply 与 Discard

完成 TODO 2：

- PR：通常产生 speculative plan，不能变成 apply。
- Push 到选定分支：触发标准 plan。
- Manual apply：成功 plan 后等待有权限的人员确认。
- Confirm：真正执行 apply。
- Discard：结束本次 run，不变更基础设施。

Auto apply 不是“不需要安全控制”，而是把批准条件交给受保护分支、CI、policy 和权限体系。

## 阶段 3：Monorepo Workspace 设计

完成 TODO 3。

如果仓库结构是：

```text
repository/
├─ network/
└─ app/
```

建议创建两个 workspace：

```text
network workspace → working directory: network → 独立 state
app workspace     → working directory: app     → 独立 state
```

再使用 trigger patterns 避免 `app/` 变化触发 network run，反之亦然。

## 阶段 4：Remote Run 认证

完成 TODO 4。

原视频采用长期 AWS access key 和 AdministratorAccess，是旧式教学演示，不应直接复制到生产。

当前推荐方向：

```text
HCP Terraform
→ 生成 OIDC workload identity
→ AWS 验证 organization/project/workspace/run claims
→ 返回本次 run 的短期凭证
→ Run 结束后凭证失效
```

这样可以：

- 避免保存长期 secret access key；
- 缩短凭证有效期；
- 按 project/workspace 限制 Role；
- 为 plan/apply 使用最小权限。

仅勾选 `sensitive` 不能修复长期管理员密钥权限过大的问题。

## 可选真实观察

如果已有自己的 HCP/GitHub 学习账号，可以创建不含云资源的测试仓库，观察 workspace 的 VCS settings、working directory 和 speculative plan 选项。不要创建 AdministratorAccess key，也不要把真实凭证放进实验仓库。

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

1. PR speculative plan 能否直接 apply？
2. Manual apply 和 discard 分别产生什么结果？
3. Monorepo 为什么需要 working directory 和 trigger patterns？
4. 两套配置为什么应该使用独立 workspace/state？
5. 动态凭证为什么优于长期 AdministratorAccess key？

## 官方参考

- [Configure workspace VCS connections](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/settings/vcs)
- [HCP Terraform run modes](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/run/modes-and-options)
- [Dynamic provider credentials](https://developer.hashicorp.com/terraform/tutorials/cloud/dynamic-credentials)
