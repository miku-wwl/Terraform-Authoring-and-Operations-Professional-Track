# Lab 40：文件存在性 precondition

本实验用 `fileexists()` 和非空判断模拟应用配置依赖数据库凭据文件的场景。

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
