# 第 9 节参考实验

本实验训练 provider plugin cache 的价值：减少重复下载、降低带宽消耗、提升多项目初始化速度。

```sh
mkdir -p .terraform-plugin-cache
export TF_PLUGIN_CACHE_DIR=/workspace/practice/labs/9/.terraform-plugin-cache
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

