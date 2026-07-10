# Lab 125：HCP Terraform Variable Sets 概念判断

本节只学习 Variable Set 的复用、ownership、scope、变量类型、优先级与安全边界，不连接真实 HCP Terraform，也不做 JSON 数据处理题。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 根据共享范围选择 organization-owned 或 project-owned Variable Set。
2. 区分 Terraform variable 与 environment variable。
3. 判断普通变量覆盖、Priority Variable Set 和 Local execution mode。
4. 判断 sensitive、动态凭据与最小作用域的安全边界。

每完成一段，可以运行：

```powershell
cd work/125
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
