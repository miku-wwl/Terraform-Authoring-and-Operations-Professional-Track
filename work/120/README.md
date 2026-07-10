# Lab 120：Organization、Project 与 Workspace

本节学习 HCP Terraform 的内部组织结构，以及 remote workspace 与本地 working directory 的区别。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 匹配 organization、project、workspace 的职责。
2. 比较配置、变量、state 和 run history 的保存位置。
3. 区分 VCS-driven、CLI-driven 和 API-driven workflow。
4. 按团队/业务域设计 project 与 workspace。

每完成一段，可以运行：

```powershell
cd work/120
terraform init -input=false
terraform plan -input=false -no-color
```

最终验收：

```powershell
terraform fmt
terraform validate
terraform test
```

本 Lab 没有资源，不需要执行 `apply` 或 `destroy`，也不需要 HCP token。
