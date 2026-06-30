# Lab 29：`jsonencode` 与 `jsondecode`

本实验一方面把 Terraform object 编码为 JSON 文件，另一方面读取外部 JSON 文件并解码为 Terraform 原生数据结构。

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

`jsonencode` 适合把 Terraform 数据交给外部系统；`jsondecode` 适合把外部 JSON 转为可筛选、可组合的数据。
