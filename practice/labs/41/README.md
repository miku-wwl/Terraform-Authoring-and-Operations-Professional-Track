# Lab 41：Check block

本实验用 `check` block 验证服务 URL 合约。`check` 不属于某个资源生命周期，适合表达额外的健康检查或合规检查。

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

负向测试：

```sh
terraform plan -input=false -no-color -var 'service_url=http://example.com'
```
