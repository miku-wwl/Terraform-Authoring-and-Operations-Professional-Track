# Lab 28：Indented heredoc 的前导空白规则

本实验用不均匀缩进的 YAML 片段说明 `<<-EOT` 的规则：Terraform 会找到所有行共同的最短前导空白，并从每一行移除相同数量。

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

这个规则适合让 Terraform 代码保持缩进，同时让生成文件不带多余外层缩进。
