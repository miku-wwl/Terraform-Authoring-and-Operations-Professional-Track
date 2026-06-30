# Lab 23：Targeting 与依赖方向

本实验通过 `random_integer` 和依赖它的 `local_file` 说明 targeting 的方向性：目标资源依赖的上游会被包含，但依赖目标资源的下游不会因为 targeting 自动展开。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -target=random_integer.build_number -out=tfplan
terraform apply -auto-approve tfplan
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

第一轮 targeted apply 只创建随机数，第二轮完整 apply 才创建依赖它的 manifest。
