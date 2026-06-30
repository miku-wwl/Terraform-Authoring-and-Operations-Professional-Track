# Lab 30：从 JSON 中提取指定字段

本实验读取服务目录 JSON，通过 `jsondecode`、索引访问和 `for` 表达式筛选出 backend 服务，并生成摘要文件。

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

生产中经常需要从外部 JSON 中提取部分字段，再喂给 Terraform 资源、模块或输出。
