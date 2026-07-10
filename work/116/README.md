# Lab 116：Terraform 调试环境变量实战

Lab 115 比较 INFO 和 TRACE 的详细程度；本节继续练习：

1. 不设置 `TF_LOG_PATH` 时，日志显示在终端 stderr。
2. 设置 `TF_LOG_PATH` 后，日志写入文件。
3. 环境变量只在当前终端会话及其子进程中生效。
4. 清除环境变量后，后续 plan 不再追加 debug log。

完整操作和答案级 Hint 已直接写在 `main.tf` 顶部。请从 TODO 1 开始按顺序执行。

进入目录：

```powershell
cd work/116
```

最终验收：

```powershell
terraform fmt
terraform validate
terraform test
```

本 Lab 不需要修改 Terraform 配置，也不需要 `apply` 或 `destroy`。配置中的 `local_file` 只提供 plan 目标，因此不会真的创建 `debug-target.txt`。`terraform-debug.log` 是临时排障文件，不应提交 Git。
