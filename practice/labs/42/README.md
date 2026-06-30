# Lab 42：Sensitive 参数

本实验使用 `sensitive = true` 标记输入变量和输出，观察 Terraform 在 CLI 中如何隐藏敏感值。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform output api_token
terraform destroy -auto-approve
```

注意：敏感值仍会进入 state，不能把 state 当成普通日志文件处理。
