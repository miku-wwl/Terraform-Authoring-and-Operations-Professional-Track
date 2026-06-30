# Lab 19：Terraform import 工作流

本实验用 `terraform_data` 模拟已经存在的遗留资源，训练 import 前的识别、映射、生成配置和状态接管流程。

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

课程中的安全组示例需要 AWS，本实验是本地替代实验，不等价于真实 AWS 导入。
