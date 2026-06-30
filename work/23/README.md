# 第 23 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/23/ 中的参考实现。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-23 `
  -v "${PWD}/work/23:/workspace" `
  -w /workspace `
  --entrypoint sh `
  hashicorp/terraform:1.11
```

容器内建议执行：

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -target=random_integer.build_number -out=tfplan
terraform apply -auto-approve tfplan
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

最终验证时会使用 `terraform fmt -check`。