# 第 18 节参考实验

本实验训练 `TF_IN_AUTOMATION`：在 CI/CD 中减少 Terraform 的下一步提示，让日志更短、更适合排障和归档。

```sh
export TF_IN_AUTOMATION=true
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

