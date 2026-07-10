# Lab 124：CLI-driven Workflow 步骤与排障

本节只学习 CLI-driven workflow 的步骤、职责和常见故障，不执行真实登录或远端操作。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 排列 cloud、login、init、plan/apply 的顺序。
2. 匹配每个步骤的职责。
3. 根据报错选择正确的排查入口。
4. 判断 token 安全和远端执行证据。

每完成一段，可以运行：

```powershell
cd work/124
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
