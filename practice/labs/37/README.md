# Lab 37：密码长度验证

本实验使用变量 `validation` 和 `length()` 函数限制数据库密码长度。

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

负向测试：

```sh
terraform plan -input=false -no-color -var 'db_password=short'
```
