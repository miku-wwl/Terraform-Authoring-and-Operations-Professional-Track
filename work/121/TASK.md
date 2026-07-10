# Terraform 实操训练 121：创建 Workspace 与选择 Workflow

## 本节主旨

创建 organization、project 和 workspace 只是搭建容器。真正决定后续工作方式的是 workspace workflow 和相关设置。

```text
Organization
→ Default Project 或自定义 Project
→ 在 Project 中创建 Workspace
→ 选择 VCS / CLI / API workflow
→ 配置版本、变量、凭证、权限和运行策略
→ 第一次 Run
```

## 阶段 1：创建顺序

完成 `main.tf` 的 TODO 1。

新 organization 通常会提供 Default Project。学习或小型场景可以先使用它；生产环境可以根据团队、系统或权限边界创建自定义 project。

Workspace 必须属于某个 project。创建 workspace 后仍要继续配置，它不是一创建就自动具备代码和云权限。

## 阶段 2：Workflow 选型

完成 TODO 2：

| 场景 | 推荐 workflow |
|---|---|
| Git PR 是唯一变更入口 | VCS-driven |
| 工程师希望继续使用本地 Terraform CLI | CLI-driven |
| 内部平台或 CI 上传配置并调用 API | API-driven |

选择的关键不是哪个“更高级”，而是谁是配置 source of truth、谁触发 run、现有团队流程是什么。

## 阶段 3：Workspace 上线检查

完成 TODO 3。第一次正式 run 前至少检查：

- workspace 名称和所属 project；
- workflow 和配置来源；
- Terraform 版本和 execution mode；
- Terraform variables、environment variables 和云认证；
- 团队权限；
- auto-apply、policy checks 和审批设置。

空 workspace 只表示对象存在，不表示生产工作流已经准备好。

## 阶段 4：Registry 与 Settings

完成 TODO 4：

- Private registry：共享组织内部 module/provider。
- Organization settings：用户、团队、套餐、计费和组织级设置。
- Workspace：配置、变量、state、runs 和执行设置。

Private registry 不是 state backend，也不是存放 workspace run history 的位置。

## 可选真实观察

如果你已经自愿创建 HCP Terraform 学习账号，可以在独立的 sandbox organization 中：

1. 查看 Default Project；
2. 新建一个 `terraform-learning` project；
3. 打开创建 workspace 页面；
4. 观察 VCS、CLI、API workflow 选项；
5. 不需要连接真实云账号，也不要上传凭证。

UI 观察不是自动测试前提。

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

1. 创建 workspace 前为什么需要 organization/project？
2. Git PR 驱动的团队应选择什么 workflow？
3. CLI-driven 是否仍然使用本地 Terraform 命令？
4. 空 workspace 为什么还不能直接用于生产 apply？
5. Private registry 和 workspace 分别保存什么？

## 官方参考

- [Sign up and create an organization](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up)
- [HCP Terraform workflows](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started)
- [HCP Terraform workspaces](https://developer.hashicorp.com/terraform/cloud-docs/workspaces)
