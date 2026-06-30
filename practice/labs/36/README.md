# Lab 36：输入变量验证基础

本实验用 `validation` 限制工作区名称只能包含小写字母、数字和连字符。

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
terraform plan -input=false -no-color -var 'workspace_name=Team#Dev'
```
