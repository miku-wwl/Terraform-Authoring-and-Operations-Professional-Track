# Lab 117：HCP Terraform 概览

本节是 HCP Terraform 概念入门，不需要 HCP Terraform 账号、云账号或外部 provider。

请直接阅读 `main.tf` 顶部的知识总结，并按 TODO 1～4 逐段完成。每个 TODO 都包含完整答案级 Hint，不需要频繁切换文件。

学习路径：

1. 判断 HCP Terraform 的产品定位和常见误区。
2. 排列一个典型受治理 run 的阶段。
3. 根据团队问题选择对应的平台能力。
4. 判断 policy failure、auto-apply 与人工审批的关系。

每完成一段，可以运行下面的命令观察当前答案：

```powershell
cd work/117
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
