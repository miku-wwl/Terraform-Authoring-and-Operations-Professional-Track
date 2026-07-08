# 第 98 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/` 下的参考实现或讲义文件。

本 lab 不连接 AWS，也不访问 Terraform Registry。它用本地 module、`fileset()` 和 JSON mock 数据来练习标准 Terraform module 结构。

## 本地执行

```powershell
cd work/98
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
