# Lab 130：HCP Terraform Health Assessments

本节只学习 Drift Detection、Continuous Validation、check block、评估条件与 drift 响应，不连接真实 HCP Terraform，也不执行 HTTP 或定时脚本。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 根据场景区分 Drift Detection 与 Continuous Validation。
2. 判断 Health Assessment 是否会修改基础设施或自动修复。
3. 理解 check/precondition/postcondition 的持续验证边界。
4. 判断 workspace 条件、权限和 drift 处理方式。

每完成一段，可以运行：

```powershell
cd work/130
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
