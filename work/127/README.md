# 第 127 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `data/` 下的 mock 数据文件。

本 lab 不会连接真实 HCP Terraform，也不会创建云资源。它用 JSON mock 数据模拟 HCP Terraform 中的 organization、workspace、remote state sharing 和 run triggers 关系。

## 本地执行

```powershell
cd work/127
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
