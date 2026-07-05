# 第 122 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/` 下的参考实现或讲义文件。

本 lab 使用本地 JSON mock 数据模拟 HCP Terraform workspace、VCS workflow、workspace variables 和 run workflow。你不需要 HCP Terraform 账号、GitHub token 或 AWS 凭据。

## 本地执行

```powershell
cd work/122
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
