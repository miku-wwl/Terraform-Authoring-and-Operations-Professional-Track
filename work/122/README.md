# Lab 122：VCS-driven Workspace

本节深入学习 HCP Terraform workspace 如何连接 Git 仓库，以及 PR、push、manual apply 和 discard 如何影响 run。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 配置 repository、branch、working directory 和 trigger patterns。
2. 判断 PR、push、confirm、discard 的结果。
3. 为 monorepo 的多套 Terraform 配置隔离 workspace/state。
4. 用 OIDC 动态凭证替代长期 AdministratorAccess key。

每完成一段，可以运行：

```powershell
cd work/122
terraform init -input=false
terraform plan -input=false -no-color
```

最终验收：

```powershell
terraform fmt
terraform validate
terraform test
```

本 Lab 不需要真实 HCP、GitHub 或 AWS 账号，也不执行 `apply` 或 `destroy`。
