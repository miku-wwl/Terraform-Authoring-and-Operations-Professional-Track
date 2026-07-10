# Terraform 实操训练 119：账号、Organization 与安全边界

## 本节主旨

本节原视频演示注册 HCP Terraform 账号。考试和实际工作中更重要的不是网页按钮，而是理解下面的对象关系：

```text
User account
  └─ 可以加入一个或多个 Organization

Organization
  └─ Project
       └─ Workspace / Stack
```

账号表示“你是谁”；organization 定义团队、权限和计费边界；workspace 才关联具体 Terraform 配置、变量、state 和 runs。

## 阶段 1：对象层级

完成 `main.tf` 的 TODO 1。

需要注意：用户可以属于多个 organization，所以 user 与 organization 不是简单的一对一父子关系。这里的列表只是帮助你建立从身份到基础设施 workspace 的学习顺序。

## 阶段 2：注册不等于工作流就绪

完成 TODO 2。

注册并验证账号后，已经建立的是个人身份。它不代表：

- 已经创建 workspace；
- 已经迁移 remote state；
- 已经连接 VCS；
- 已经配置 AWS/Azure/GCP credentials；
- 已经具备某个 organization 的权限。

因此“我能登录 HCP Terraform”与“团队远程工作流已经配置完成”是两件事。

## 阶段 3：Onboarding 顺序

完成 TODO 3：

```text
打开 HCP Terraform
→ 创建或关联账号
→ 验证身份/邮箱
→ 创建或加入 organization
→ 创建 project 或使用 Default Project
→ 创建并配置 workspace
```

实际页面字段和按钮可能变化，HCP Europe 等环境的组织管理方式也可能不同。重点是理解对象依赖，不是死记 UI。

## 阶段 4：账号安全

完成 TODO 4。

- 密码不能进入 Terraform 配置或 Git。
- API token 不能通过 output 暴露。
- Token 应使用尽可能短的有效期。
- 应启用 MFA/SSO 等强认证方式。
- 邮箱验证链接也属于临时敏感链接，截图和分享时需要隐藏。

## 可选真实体验

如果你愿意创建免费学习账号：

1. 打开 [HCP Terraform](https://app.terraform.io)。
2. 使用个人学习身份注册或使用 HCP account 登录。
3. 完成要求的身份/邮箱验证。
4. 创建一个专门用于学习的 organization。
5. 暂时不需要连接真实 AWS，也不要把任何密码或 token 写入仓库。

真实注册不是自动测试的前提，也不应由脚本代替你完成。

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

1. User account 与 organization 是不是同一个概念？
2. 一个用户能否属于多个 organization？
3. 注册账号后 remote state 是否自动配置完成？
4. Organization、project、workspace 分别处于什么层级？
5. 为什么 API token 不应该通过 Terraform output 显示？

## 官方参考

- [Sign up for HCP Terraform](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up)
- [HCP Terraform users](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/users)
- [HCP Terraform organizations](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/organizations)
