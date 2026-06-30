# Lab 45：资源行为与 meta-argument

本实验用 `terraform_data` 固化 Terraform 资源行为和常见 meta-argument，为 lifecycle 学习打基础。

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
