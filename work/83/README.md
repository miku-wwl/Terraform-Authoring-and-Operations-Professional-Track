# 第 83 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform test 文件，完成 `tests/` 目录中的 TODO。

本节练习 Terraform test 文件的根级属性：`provider`、`variables` 和多个 `run` block。

## 本地执行

```powershell
cd work/83
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
