# Lab 49：`ignore_changes`

本实验用 `local_file` 模拟外部流程修改文件内容，并通过 `ignore_changes = [content]` 让 Terraform 忽略该属性漂移。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
printf '外部系统写入的内容\n' > output/managed-note.txt
terraform plan -input=false -no-color
terraform output
terraform destroy -auto-approve
```
