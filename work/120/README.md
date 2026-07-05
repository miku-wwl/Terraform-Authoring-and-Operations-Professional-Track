# 第 120 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/` 下的参考实现或讲义文件。

本 lab 使用 `data/hcp_platform.json` 模拟 HCP Terraform 的 organization、project、workspace 结构，不会连接真实 HCP Terraform，也不需要 HCP token。

## 本地执行

```powershell
cd work/120
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
