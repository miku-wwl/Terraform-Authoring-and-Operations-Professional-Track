# Terraform 实操训练 130：HCP Terraform Health Assessments

## 本节主旨

Health Assessments 周期性回答两个不同问题：

```text
真实资源是否仍符合 Terraform configuration？
  └─ Drift Detection

部署后的自定义健康条件是否仍成立？
  └─ Continuous Validation
```

本 Lab 只考平台概念。你不需要连接 HCP Terraform、创建真实资源、请求网站或编写 cron 脚本。

## 阶段 1：两类 Health Assessment

完成 `main.tf` 的 TODO 1。

| 场景 | 类型 |
|---|---|
| 控制台手工增加安全组规则 | Drift Detection |
| Bucket 设置偏离 Terraform configuration | Drift Detection |
| 网站不再返回 HTTP 200 | Continuous Validation |
| 证书过期 | Continuous Validation |

当前官方文档还区分 configuration drift 与 state drift。Health Drift Detection 检测的是使真实资源不再符合 configuration 的偏离，不应把所有 state 差异都笼统归入它。

## 阶段 2：检测不等于修复

完成 TODO 2。

Health Assessments 是周期性、非 actionable 的评估。它可以显示健康状态并触发通知，但不会：

- 自动修改云资源；
- 自动更新 Terraform state；
- 自动改写 Terraform configuration；
- 为团队决定哪一边才是正确状态。

评估不会打断正常 workspace run。如果新 run 在评估期间开始，当前评估会取消并在后续周期重新安排。

## 阶段 3：Continuous Validation

完成 TODO 3。

Continuous Validation 会定期重新评估：

- `check` blocks；
- resource/data source/output 的 preconditions；
- postconditions。

HashiCorp 推荐使用 `check` block 做 post-apply monitoring。普通 Terraform plan/apply 中，check assertion 失败产生 warning，但不会阻断当前操作；HCP Health Assessment 会把失败记录为健康问题并可触发通知。

## 阶段 4：条件、权限与处理

完成 TODO 4。

符合评估条件的 workspace 需要：

- Remote 或 Agent execution mode；
- 至少一次成功 apply；
- 最新 run 成功；
- Drift Detection 使用 Terraform 0.15.4+；
- Continuous Validation 使用 Terraform 1.3.0+。

最新 run errored、canceled 或 discarded 时，Health Assessments 会暂停，直到再次出现成功 run。

权限边界：

- 查看 health status：workspace read；
- 修改 workspace Health 设置：workspace admin；
- 触发 on-demand assessment：workspace admin；
- 强制 organization 范围启用：organization owner。

## 两种 Drift 响应

发现 drift 后不能机械地“永远以某一边为准”：

1. 外部修改不应保留：执行 plan/apply，让真实资源恢复到 configuration。
2. 外部修改已经被认可：先把修改写进 Terraform configuration，再运行 Terraform，让代码重新成为 source of truth。

直接忽略 drift 或手工编辑 state 通常都不是正确的常规处理方式。

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

1. 控制台手工修改资源属于哪类 assessment？
2. 网站返回 500 属于 drift 还是 validation failure？
3. Health Assessment 会自动修复资源或更新 state 吗？
4. `check` 失败是否会阻断普通 Terraform apply？
5. 团队决定接受 drift 时应修改 infrastructure、state 还是 configuration？

## 官方参考

- [HCP Terraform Health Assessments](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/health)
- [Detect infrastructure drift](https://developer.hashicorp.com/terraform/tutorials/cloud/drift-detection)
- [Terraform check block](https://developer.hashicorp.com/terraform/language/block/check)
- [Workspace health notifications](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/settings/notifications)
