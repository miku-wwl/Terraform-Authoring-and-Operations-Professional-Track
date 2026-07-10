# Lab 121：创建 Project、Workspace 与选择 Workflow

本节把 Lab 120 的对象结构落到创建流程和 workflow 选型。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都包含完整答案级 Hint。

学习路径：

1. 排列 organization/project/workspace 的创建顺序。
2. 为 Git、CLI 和自定义自动化选择 workflow。
3. 建立 workspace 第一次正式 run 前的检查清单。
4. 区分 private registry、organization settings 和 workspace。

每完成一段，可以运行：

```powershell
cd work/121
terraform init -input=false
terraform plan -input=false -no-color
```

最终验收：

```powershell
terraform fmt
terraform validate
terraform test
```

本 Lab 不需要真实 HCP 账号，不创建资源，也不需要执行 `apply` 或 `destroy`。
