# Lab 20：导入后生成配置的实践

本实验把 AWS 安全组导入场景改写成本地 `terraform_data` 模拟，重点练习 import block 中 `to` 和 `id` 的含义，以及 `-generate-config-out` 的使用时机。

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

真实安全组导入需要 AWS 凭证和目标资源 ID，本实验不连接 AWS。
