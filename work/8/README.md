# 第 8 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/8/ 中的参考实现。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-8 `
  -v "${PWD}/work/8:/workspace" `
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

说明：

- 本题的核心是 `-no-color`。
- `terraform test` 只验证命令文本是否符合 CI/CD 要求，不会真正生成文件。
- 产物文件由 `terraform apply` 创建。
- 真实 CI/CD 中保存 plan 文本或日志时，建议使用 `-no-color`，避免 ANSI 控制符污染日志和审批记录。
