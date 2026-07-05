# 第 144 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改其他目录下的参考材料。

## 本地执行

```powershell
cd work/144
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
