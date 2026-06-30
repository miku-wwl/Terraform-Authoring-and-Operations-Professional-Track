# Lab 114：依赖锁文件

本实验观察 .terraform.lock.hcl 的生成和 provider 版本选择。

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
