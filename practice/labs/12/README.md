# 第 12 节参考实验

本实验训练显式 provider installation 配置：本地 mirror 优先，必要时理解 direct 回退的边界。

```sh
terraform providers mirror /workspace/practice/labs/12/mirror
rm -rf .terraform .terraform.lock.hcl
TF_CLI_CONFIG_FILE=/workspace/practice/labs/12/terraform-cli.rc terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```
