# Lab 39：Precondition 与 postcondition

本实验在 `terraform_data` 资源中使用 `precondition` 和 `postcondition`，模拟只允许开发环境使用小规格资源。

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
