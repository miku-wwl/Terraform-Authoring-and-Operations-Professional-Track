# Lab 62：基于 CSV 创建多个资源

本实验使用 csvdecode 和 for_each 从 CSV 生成多个本地文件。

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
