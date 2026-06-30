# Lab 25：Quoted string 与转义序列

本实验使用 `\"`、`\\` 和 `\n` 生成包含引号、Windows 路径和多行文本的文件。

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

当字符串中需要保留双引号或反斜杠时，必须显式转义。
