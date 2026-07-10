# Lab 126：Sentinel Policy as Code 概念判断

本节只学习 Sentinel、Policy Set、enforcement level、运行阶段和治理边界，不连接真实 HCP Terraform，也不做 JSON 数据搬运题。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 区分 Sentinel、Policy 和 Policy Set。
2. 判断 advisory、soft-mandatory 和 hard-mandatory 的失败行为。
3. 判断 Policy Set 的作用域、framework 和 VCS 管理方式。
4. 根据运行阶段与 IaC/云侧边界选择控制手段。

每完成一段，可以运行：

```powershell
cd work/126
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
