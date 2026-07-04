# 第 45 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/45/ 中的参考实现。

本节用 `terraform_data` 模拟资源行为：`for_each` 控制创建/销毁集合，`input` 字段模拟原地更新，`triggers_replace` 模拟替换触发，`lifecycle` 调整替换顺序。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-45 `
  -v "${PWD}/work/45:/workspace" `
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
