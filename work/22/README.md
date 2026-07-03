# 第 22 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/22/ 中的参考实现。

> **注意：以下命令请在项目根目录 `Terraform-Authoring-and-Operations-Professional-Track` 下执行，不要在本目录 (`work/22`) 中执行。**

进入 Docker：

```powershell
# 在项目根目录下执行
docker run -it --rm --name tf-work-22 `
  -v "${PWD}/work/22:/workspace" `
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