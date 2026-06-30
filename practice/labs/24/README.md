# Lab 24：`moved` block 与资源重命名

本实验演示如何在重命名资源地址时使用 `moved` block 表达状态迁移意图，避免 Terraform 把一次重命名误判为销毁旧资源并创建新资源。

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

真实项目中应先确认旧地址已经存在于 state，再提交 `moved` block 和新资源地址。
