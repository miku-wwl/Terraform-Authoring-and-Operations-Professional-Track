# Lab 127：Run Triggers 与 Workspace 输出依赖

本节只学习 HCP Terraform workspace 之间的数据依赖、Run Trigger、state sharing 和权限边界，不连接真实 HCP Terraform，也不做 JSON 数据处理题。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 区分“读取上游输出”和“触发下游运行”。
2. 判断哪些 source run 能触发下游，以及是否自动 apply。
3. 判断 state sharing、Run Trigger 与权限的独立边界。
4. 处理失败 apply、手工云变更和依赖方向场景。

每完成一段，可以运行：

```powershell
cd work/127
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
