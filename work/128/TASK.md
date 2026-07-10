# Terraform 实操训练 128：HCP Terraform Teams 与最小权限

## 本节主旨

HCP Terraform 使用 Team 把“谁”与“可以做什么”连接起来：

```text
User ──接受邀请──► Organization
  └─加入一个或多个 Team
       └─获得 Permission
            ├─ Organization scope
            ├─ Project scope
            └─ Workspace scope
```

本 Lab 只考身份和授权概念。你不需要连接 HCP Terraform、邀请真实用户，或用 JSON 模拟成员数据。

## 阶段 1：Membership 对象

完成 `main.tf` 的 TODO 1。

| 对象 | 职责 |
|---|---|
| User account | 代表一个人的身份 |
| Invitation | 邀请用户加入 organization |
| Team | 按平台、开发、安全、审计等职责分组用户 |
| Permission | 定义 Team 在某个范围可以执行的操作 |

一个用户可以属于多个 Team。邀请用户加入 organization 并不等于应给他 Owners 权限。

## 阶段 2：Owners Team

完成 TODO 2。

标准 HCP Terraform organization 都有 Owners Team，其成员拥有：

- 所有 organization-level permissions；
- 所有 workspaces 和 Stacks 的最高权限；
- 一些只有 owners 才能执行的成员和安全管理操作。

因此 Owners Team 应保持很小，只包含真正负责 organization 管理和应急恢复的人。最后一名 owner 不能直接离开 organization，以避免组织失去管理者。

## 阶段 3：权限是叠加的

完成 TODO 3。

Team 权限可以授予在 organization、project 和 workspace 范围。用户属于多个 Team 时，有效权限会叠加，最终获得其中能够授予的最高访问能力。

例如：

```text
Team A：workspace read
Team B：同一 workspace admin
最终有效权限：admin
```

把该用户再加入一个 `read-only` Team 不会撤销 admin。发现权限过大时，必须检查该用户的所有 Team，以及 organization/project/workspace 各范围的授权来源。

## 阶段 4：企业访问场景

完成 TODO 4。

| 人员/身份 | 推荐方式 |
|---|---|
| 只负责一个应用 project 的开发者 | Developer Team + project scope |
| 只查看一个 workspace run 的外包审计员 | Read-only Team + workspace scope |
| 平台自动化 | 独立、最小权限的 Team token |
| Organization 管理员 | 小范围 Owners Team |

不要共享 owner 账号，也不要让 CI 使用个人 owner token。Token 拥有对应用户或 Team 的权限，泄露后的影响与该身份权限一致。

## HCP Europe 的区别

HCP Europe organization 使用 HCP Groups 和 roles 管理用户，传统 Team permissions 和 Owners Team 不适用。考试或实际排障时，要先确认使用的是标准 HCP Terraform organization 还是 HCP Europe organization。

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

1. Invitation、Team 和 Permission 分别解决什么问题？
2. 为什么不能让所有开发者加入 Owners Team？
3. 给已有 admin 权限的用户增加 read-only Team，会降低权限吗？
4. 外包人员只看一个 workspace run 时应如何授权？
5. HCP Europe 为什么不能照搬传统 Owners Team 模型？

## 官方参考

- [Create and manage users](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/users)
- [Teams overview](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/teams)
- [Permission model](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/permissions)
- [Organization owners](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/permissions/organization#organization-owners)
