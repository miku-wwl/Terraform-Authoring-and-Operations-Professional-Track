# Lab 27：基础 heredoc 与 indented heredoc

本实验同时生成基础 heredoc 和 indented heredoc 的输出文件，用于比较 `<<EOT` 与 `<<-EOT` 对前导空白的处理差异。

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

基础 heredoc 保留前导空白，indented heredoc 会移除所有行共同的最短前导空白。
