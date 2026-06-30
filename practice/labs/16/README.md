# 第 16 节参考实验

本实验训练保存 Terraform plan，并从同一个 plan 文件 apply，保证审批内容和执行内容一致。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform show tfplan
terraform show -json tfplan > plan.json
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

