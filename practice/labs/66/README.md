# Lab 66：模板处理 map 和循环

本实验在 templatefile 中使用 for 表达式渲染服务端口清单。

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
