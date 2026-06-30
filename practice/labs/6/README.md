# 第 6 节参考实验

本实验用本地文件生成 Terraform CLI 速查文档，训练 `terraform <command> -help` 和常用自动化参数。

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

