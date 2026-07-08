# 第 96 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改其他 lab 的文件。

本 lab 使用 `terraform_data` 模拟 EC2 instance 和 Elastic IP association，不会创建真实 AWS 资源，也不需要 AWS 凭据。

## 本地执行

```powershell
cd work/96
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
