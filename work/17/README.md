# 第 17 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/17/ 中的参考实现。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-17 `
  -v "${PWD}/work/17:/workspace" `
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
terraform plan -input=false -no-color -out=tfplan -var 'host_network_enabled=true'
terraform show -json tfplan > plan.json
```

本实验只生成和扫描 plan，不要求执行 `terraform apply`。