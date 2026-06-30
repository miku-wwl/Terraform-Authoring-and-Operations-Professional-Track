# 第 8 节参考实验

本实验训练 `-no-color`：面向机器解析或归档的 Terraform 输出不应包含终端颜色控制符。

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

