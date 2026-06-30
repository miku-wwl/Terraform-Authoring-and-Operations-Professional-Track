# Lab 47：`create_before_destroy`

本实验用 `terraform_data.triggers_replace` 模拟不可原地更新的镜像版本，并启用 `create_before_destroy`。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform plan -input=false -no-color -var 'image_version=v2' -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```
