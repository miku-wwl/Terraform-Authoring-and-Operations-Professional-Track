# Lab 67：JSON mock 数据与 for 表达式

本实验读取 JSON mock 数据并筛选 backend 应用。

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
