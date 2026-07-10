# Terraform 实操训练 127：Run Triggers 与 Workspace 输出依赖

## 本节主旨

两个 workspace 之间的依赖包含两条不同通道：

```text
Source / Upstream workspace
  ├─ Root outputs ────────► Target / Downstream 读取数据
  │
  └─ Successful apply ───► Run Trigger 排队下游 run
```

输出访问回答“下游读取什么”，Run Trigger 回答“下游何时重新评估”。只有其中一条通道，依赖关系都可能不完整。

## 阶段 1：数据与触发分离

完成 `main.tf` 的 TODO 1。

- `terraform_remote_state` 或 `tfe_outputs`：读取上游 root outputs。
- Run Trigger：上游成功 apply 后，给下游排队一个新 run。
- Source：产生输出并完成 apply 的上游 workspace。
- Target/Dependent：读取输出、被排队运行的下游 workspace。

仅读取输出不会自动产生下游 run；仅配置 trigger 也不会自动赋予读取上游 state/output 的权限。

## 阶段 2：触发条件与 Auto Apply

完成 TODO 2。

Run Trigger 的触发条件是 source workspace **成功完成 apply**：

| Source 结果 | 是否触发下游 |
|---|---|
| Speculative plan | 否 |
| Plan/apply 失败 | 否 |
| Apply 成功 | 是，排队一个 run |

“自动排队 run”不等于“自动 apply”。由 Run Trigger 创建的下游 run 默认仍需要确认；若团队确实需要，可以单独启用针对 Run Trigger 的 auto-apply 设置。

## 阶段 3：State Sharing 与权限

完成 TODO 3。

新 workspace 默认不允许其他 workspace 读取其 state。可以分享给整个 organization、同一 project 或指定 workspaces，但生产环境应遵循最小权限，优先只授权必要的消费者。

创建 Run Trigger 时，需要：

- 对下游 target workspace 具有 admin access；
- 对上游 source workspace 具有读取 runs 的权限。

这再次说明 Run Trigger 与 state access 是两套独立权限。

## 阶段 4：依赖场景判断

完成 TODO 4。

典型网络依赖：

1. `network` workspace 输出 subnet IDs。
2. `application` workspace 获得读取这些 outputs 的权限。
3. 在 `application` 上建立来自 `network` 的 inbound Run Trigger。
4. `network` 成功 apply 后，`application` 自动排队 run 并重新读取 outputs。

在 API/UI 术语中：target 上看到的是 inbound trigger，source 上看到的是 outbound trigger。

Run Trigger 只观察 HCP Terraform 的成功 apply。有人直接在云控制台修改资源时，需要 drift detection、scheduled runs、provider data source 或云侧审计等机制，而不是期待 Run Trigger 自动响应。

## 为什么不合并成巨大 Workspace

为了避免依赖而把网络、安全、数据库和应用全部放入一个 workspace，通常会带来：

- 更大的 blast radius；
- 更长、更嘈杂的 plan；
- 团队权限和责任边界模糊；
- 任一变更都锁住同一个 state/run queue。

合理拆分 workspace，再明确输出接口和触发方向，通常更容易治理。

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

1. Remote outputs 与 Run Trigger 分别解决什么问题？
2. Source workspace 只有 plan 成功但没有 apply，会触发下游吗？
3. 下游 run 被自动排队，是否等于一定自动 apply？
4. 配置 Run Trigger 是否自动授予 remote state 读取权？
5. Inbound 和 outbound trigger 分别从哪个 workspace 观察？

## 官方参考

- [HCP Terraform Run Triggers API](https://developer.hashicorp.com/terraform/cloud-docs/api-docs/run-triggers)
- [Manage workspace state and output access](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/state)
- [Connect workspaces with Run Triggers](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-run-triggers)
- [Workspace Run Trigger settings](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/settings#run-triggers)
