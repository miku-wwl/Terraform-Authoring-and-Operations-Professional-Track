# Lab 116：TF_LOG 与 TF_LOG_PATH

本实验设置 Terraform 调试日志并将日志写入文件。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
mkdir -p logs
TF_LOG=TRACE TF_LOG_PATH=logs/terraform-debug.log terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```
