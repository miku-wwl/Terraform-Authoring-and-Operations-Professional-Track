# 第 10 节参考实验

本实验训练 plugin cache 的实际落地方式，并生成 Terraform CLI 配置示例。

```sh
mkdir -p .terraform-plugin-cache
export TF_PLUGIN_CACHE_DIR=/workspace/practice/labs/10/.terraform-plugin-cache
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

