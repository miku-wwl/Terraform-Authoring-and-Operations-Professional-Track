# Lab 38：多条件变量验证

本实验使用 `contains()` 为实例规格和环境建立允许列表。

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
terraform plan -input=false -no-color -var 'instance_size=xlarge'
```
