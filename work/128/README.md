# Lab 128：HCP Terraform Teams 与最小权限

本节只学习用户邀请、Team、Owners Team、权限叠加和企业访问场景，不连接真实 HCP Terraform，也不做 JSON 数据处理题。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 区分 User、Invitation、Team 与 Permission。
2. 判断 Owners Team 的权限与安全边界。
3. 理解 organization/project/workspace 权限范围和叠加规则。
4. 为开发者、审计员、外包和自动化身份设计最小权限。

每完成一段，可以运行：

```powershell
cd work/128
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
