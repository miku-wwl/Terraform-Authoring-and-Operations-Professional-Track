# Lab 129：HCP Terraform Workspace Permissions

本节只学习 Read、Plan、Write、Admin、Custom workspace 权限，以及 runs、variables、state 和敏感数据边界，不连接真实 HCP Terraform，也不做 JSON 数据处理题。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 根据职责选择预设角色或 Custom role。
2. 判断 Read、Plan、Write、Admin 的关键能力。
3. 区分 outputs-only、完整 state 和 state write。
4. 处理审计、Sensitive variables、Sentinel mocks 和 Run Tasks 权限。

每完成一段，可以运行：

```powershell
cd work/129
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
