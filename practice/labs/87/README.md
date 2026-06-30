# Lab 87：选择合适模块

本实验使用本地 child module 创建文件产物，训练模块的生产化组织方式。

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
