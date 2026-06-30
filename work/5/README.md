# 第 5 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/labs/5/` 中的参考实现。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-5 `
  -v "${PWD}/work/5:/workspace" `
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

