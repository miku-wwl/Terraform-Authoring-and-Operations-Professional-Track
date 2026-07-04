# 第 42 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/42/ 中的参考实现。

本节重点练习 `sensitive = true`、敏感 output 标记、非敏感派生状态，以及 `terraform.tfstate` / plan 文件仍可能包含敏感信息的风险。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-42 `
  -v "${PWD}/work/42:/workspace" `
  -w /workspace `
  --entrypoint sh `
  hashicorp/terraform:1.11
```

容器内执行：

```sh
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
