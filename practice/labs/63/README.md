# Lab 63：嵌套 for 表达式

本实验训练 嵌套 for 表达式 的生产化用法。

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
