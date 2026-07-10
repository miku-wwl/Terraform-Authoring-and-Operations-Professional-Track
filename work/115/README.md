# Lab 115：Terraform Debugging

本节学习 `TF_LOG` 和 `TF_LOG_PATH`。你会亲自生成 INFO 与 TRACE 日志，而不是处理模拟数据。

主要操作和答案级 Hint 已经直接写在 `main.tf` 顶部。请按 TODO 1～4 顺序执行，不要一开始连续运行所有命令。

学习路径：

1. 普通 `terraform plan`：观察默认输出。
2. `TF_LOG=INFO`：生成并打开 `terraform-info.log`。
3. `TF_LOG=TRACE`：生成并打开 `terraform-trace.log`。
4. 比较日志详细程度，清除环境变量，再运行测试。

进入目录：

```powershell
cd work/115
```

最终验收：

```powershell
terraform fmt
terraform validate
terraform test
```

本 Lab 只运行 `plan`，不需要 `apply` 或 `destroy`。生成的 debug log 是临时排障材料，不应提交 Git。
