# 第 7 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/7/ 中的参考实现。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-7 `
  -v "${PWD}/work/7:/workspace" `
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
terraform plan -input=false -var artifact_name=ci-artifact.txt -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve -var artifact_name=ci-artifact.txt
```

最终验证时会使用 `terraform fmt -check`。

说明：

- `terraform test` 只验证命令链是否符合非交互式要求，不会生成 `output/ci-artifact.txt`。
- 产物文件由 `terraform apply` 创建。
- 本题不要依赖 `terraform.tfvars` 自动加载变量，重点是练习在 CI/CD 命令中显式传入 `-var artifact_name=ci-artifact.txt`。
