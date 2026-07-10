# Terraform 实操训练 126：Sentinel Policy as Code 概念

## 本节主旨

Sentinel 把组织治理规则放在成功的 Terraform plan 与 apply 之间：

```text
Terraform run
  └─ Successful plan
       └─ Post-plan run tasks / Cost estimation
            └─ Sentinel policy check
                 ├─ Pass：允许进入后续流程
                 ├─ Advisory fail：警告后继续
                 ├─ Soft-mandatory fail：等待授权覆盖或终止
                 └─ Hard-mandatory fail：不能进入 apply
```

本 Lab 只考平台概念。你不需要连接 HCP Terraform、编写 Sentinel 语言，或用 JSON 模拟 Policy Set。

## 阶段 1：三个核心对象

完成 `main.tf` 的 TODO 1。

| 对象 | 职责 |
|---|---|
| Sentinel | HashiCorp policy as code framework |
| Policy | 一条治理规则 |
| Policy Set | 组织多条 policy 并分配作用范围 |

Policy 可以检查 Terraform plan、配置、state 和 run 数据。例如：限制生产区域、禁止过大实例、要求资源标签。

## 阶段 2：Enforcement Level

完成 TODO 2。

- `advisory`：失败只告警，run 继续。
- `soft-mandatory`：失败后暂停，只有具备 policy override 权限的人员才能覆盖。
- `hard-mandatory`：必须通过，当前 run 中不能覆盖。

Enforcement level 不写在 policy 判断逻辑里，而是在部署 policy 时配置。因此同一规则可以在测试环境先 advisory，在生产环境设为 hard-mandatory。

## 阶段 3：Policy Set 的分发

完成 TODO 3。

Policy Set 可以：

- 全局应用到 organization；
- 应用到指定 projects 或 workspaces；
- 按 workspace tags 匹配范围（该连接方式目前为 Beta）；
- 从 VCS 管理和更新，以保留 review、版本与审计记录。

一个 Policy Set 只能包含同一种 framework 的 policies，但同一 workspace 可以同时关联 Sentinel 和 OPA Policy Sets。

不要继续记忆旧结论“Sentinel 一定要求付费”：HashiCorp 当前文档说明 HCP Terraform Free 包含一个最多五条 policies 的 Policy Set；套餐限制以后仍应查阅最新官方文档。

## 阶段 4：运行阶段与治理边界

完成 TODO 4。

Sentinel 只评估成功的 Terraform plan。如果 plan 本身失败，不会进入 policy check。

要求 Terraform 部署的资源必须有标签，适合使用 Sentinel 在 apply 前检查；但有人绕过 Terraform、直接从云控制台创建资源时，Sentinel 不会自动看到或阻止它。此时需要云侧权限、审计、AWS Config/Azure Policy 等持续合规控制。

因此成熟治理通常包含两层：

1. IaC pipeline/run 的部署前政策检查。
2. 云平台侧的权限限制、审计、漂移和持续合规检测。

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

1. Sentinel Policy Check 在 plan 之前还是之后？
2. Policy 与 Policy Set 有什么区别？
3. 哪种 enforcement level 可以由授权人员覆盖？
4. Hard-mandatory 失败后 workspace admin 是否一定能强行 apply？
5. 为什么 Sentinel 不能替代云侧持续合规控制？

## 官方参考

- [HCP Terraform policy enforcement overview](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/policy-enforcement)
- [Policy enforcement results and overrides](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/policy-enforcement/view-results)
- [Sentinel enforcement levels](https://developer.hashicorp.com/sentinel/docs/concepts/enforcement-levels)
- [Configure Policy Set connections](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/policy-enforcement/manage-policy-sets/configure)
