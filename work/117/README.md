# 第 117 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改测试文件来绕过验收。

## 本地执行

```powershell
cd work/117
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

这个 lab 完全在本地运行，不需要 HCP Terraform 账号、云账号或外部 provider。

最终验证时会使用 `terraform fmt -check`。
