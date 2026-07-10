# Lab 119：HCP Terraform 账号与 Organization

本节学习账号注册的意义，以及 user、organization、project、workspace 的关系。

必做部分不需要真实 HCP Terraform 账号。请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成；每个 TODO 都包含完整答案级 Hint。

学习路径：

1. 排列主要对象层级。
2. 判断注册账号后哪些内容仍未配置。
3. 排列从身份注册到 workspace 的概念步骤。
4. 判断账号、密码和 API token 的安全做法。

每完成一段可以运行：

```powershell
cd work/119
terraform init -input=false
terraform plan -input=false -no-color
```

最终验收：

```powershell
terraform fmt
terraform validate
terraform test
```

本 Lab 没有资源，不需要执行 `apply` 或 `destroy`。

如果你愿意体验真实 UI，可以访问 [HCP Terraform](https://app.terraform.io)，使用自己的账号完成注册、邮箱验证，并创建独立的学习 organization。不要把密码、token 或验证链接写入本仓库。
