# Lab 22：`random_integer` 与唯一命名

本实验用 `random_integer` 为本地产物生成唯一后缀，模拟生产中为全局唯一资源名追加随机数的做法。

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

随机值会进入 state；只要资源没有被替换，后续 apply 会保持同一个值。
