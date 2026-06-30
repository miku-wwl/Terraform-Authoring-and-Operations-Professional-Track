# 第 7 节参考实验

本实验训练 `-input=false`：自动化环境不能等待人工输入，缺少变量时应该快速失败。

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan -var artifact_name=ci-artifact.txt
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve -var artifact_name=ci-artifact.txt
```
