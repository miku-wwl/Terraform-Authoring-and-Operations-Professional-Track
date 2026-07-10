# Lab 123：CLI-driven Workflow 概念判断

本节只学习 HCP Terraform CLI-driven workflow 的基础概念，不连接真实 HCP Terraform，也不执行远端命令。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 根据团队场景选择 VCS、CLI 或 API-driven workflow。
2. 区分 cloud block、terraform login 和 provider 认证。
3. 判断 plan/apply/destroy 的本地发起与远端执行行为。
4. 判断新建 CLI-driven workspace 还缺少哪些设置。

每完成一段，可以运行：

```powershell
cd work/123
terraform init -input=false
terraform plan -input=false -no-color
```

全部完成后验收：

```powershell
terraform fmt
terraform validate
terraform test
```

本 Lab 没有资源，不需要执行 `apply` 或 `destroy`。
