# 第 68 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/` 下的参考实现或讲义文件。

本 lab 使用 `terraform_data` 模拟 AWS Security Group 与 ingress/egress rule，不需要真实 AWS 账号或云资源。练习重点是 CSV 数据读取、过滤、map 转换与 `for_each`。

## 本地执行

```powershell
cd work/68
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
