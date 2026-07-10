# 第 124 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要直接连接真实 HCP Terraform workspace 完成基础验收。

本 lab 使用本地 mock 数据模拟 HCP Terraform 的 CLI-driven run workflow，因此不需要 HCP Terraform 账号、登录 token 或云厂商凭据。

## 本地执行

```powershell
cd work/124
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

最终验证时会使用 `terraform fmt -check`。

## 可选：连接真实 HCP Terraform

完成本地练习后，可以复制 `cloud-config.tf.example` 为单独实验目录中的 `.tf` 文件，替换 organization 和 workspace，再执行：

```powershell
terraform login app.terraform.io
terraform init
terraform plan
terraform apply
```

不要把 `~/.terraform.d/credentials.tfrc.json`、登录 token、AWS access key 或其他凭据提交到 Git。
