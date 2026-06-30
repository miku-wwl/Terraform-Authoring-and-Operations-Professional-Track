# Lab 26：Heredoc 多行字符串

本实验使用基础 heredoc 生成一段 shell 脚本，适合训练脚本、配置文件、JSON 文档等多行内容的维护方式。

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

基础 heredoc 会保留内容中的换行和缩进。
