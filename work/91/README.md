# 第 91 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/` 下的参考实现或讲义文件。

本 lab 会从 `work/91` 作为 root module 执行。真正需要补全的团队调用文件在 `teams/team-a/module.tf`。

## 本地执行

```powershell
cd work/91
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
