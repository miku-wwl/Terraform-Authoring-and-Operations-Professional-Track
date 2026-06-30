# Lab 60：csvdecode 基础

本实验读取 CSV 服务清单并筛选启用的服务。

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
