# Lab 131：迁移 Local State 到 HCP Terraform

本节只学习 state migration 的准备、cloud/login/init 职责、init 参数和迁移后验证，不连接真实 HCP Terraform，也不迁移真实 state。

请直接阅读 `main.tf` 顶部知识总结，按 TODO 1～4 完成。每个 TODO 都提供完整答案级 Hint。

学习路径：

1. 判断迁移前的冻结、备份、版本和目标 workspace 条件。
2. 区分 cloud block、terraform login 和 terraform init。
3. 判断 `-migrate-state`、`-force-copy` 与 `-reconfigure`。
4. 判断迁移后的 state、plan、variables、credentials 和版本策略。

每完成一段，可以运行：

```powershell
cd work/131
terraform init -input=false
terraform plan -input=false -no-color
```

这里运行的只是本地概念题配置，不包含真实 `cloud` block，也不会迁移 state。

全部完成后验收：

```powershell
terraform fmt
terraform validate
terraform test
```

本 Lab 没有资源，不需要执行 `apply` 或 `destroy`。
