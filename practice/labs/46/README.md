# Lab 46：Lifecycle meta-argument 总览

本实验梳理 `create_before_destroy`、`prevent_destroy`、`ignore_changes`、`replace_triggered_by` 的用途。

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
