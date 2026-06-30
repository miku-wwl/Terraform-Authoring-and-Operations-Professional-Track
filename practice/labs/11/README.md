# 第 11 节参考实验

本实验训练 file system mirror 的基本配置。先生成 mirror，再通过 `TF_CLI_CONFIG_FILE` 让 Terraform 从 mirror 安装 provider。

```sh
terraform providers mirror /workspace/practice/labs/11/mirror
rm -rf .terraform .terraform.lock.hcl
TF_CLI_CONFIG_FILE=/workspace/practice/labs/11/terraform-cli.rc terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```
