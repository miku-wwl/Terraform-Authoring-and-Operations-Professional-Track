# Lab 115：Terraform 调试概览

本实验记录 Terraform 调试流程和核心日志环境变量。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```
