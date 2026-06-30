# 第 5 节参考实验

本实验在本地模拟 Terraform 自动化工作流，不会创建任何 AWS 资源。

在仓库根目录使用 Docker 运行：

```powershell
docker run --rm `
  -v "${PWD}:/workspace" `
  -w /workspace/practice/labs/5 `
  --entrypoint sh `
  hashicorp/terraform:1.11 `
  -c "terraform init -input=false && terraform fmt -check && terraform validate && terraform test && terraform plan -input=false -no-color -out=tfplan && terraform apply -auto-approve tfplan && terraform output && terraform destroy -auto-approve"
```
