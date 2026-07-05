# 第 131 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/` 下的参考实现或讲义文件。

本 lab 不会连接真实的 HCP Terraform，也不会要求执行 `terraform login`。它使用 `data/state_migration.json` 作为 mock 数据，帮助你练习把本地 Terraform state 迁移到 HCP Terraform 的流程转换成 Terraform 表达式和可测试输出。

## 本地执行

```powershell
cd work/131
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

最终验证时会使用 `terraform fmt -check`。
