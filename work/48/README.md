# 第 48 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/48/ 中的参考实现。

进入 Docker：

```powershell
docker run -it --rm --name tf-work-48 `
  -v "${PWD}/work/48:/workspace" `
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
terraform destroy -auto-approve
```

`terraform destroy` 在本实验中应该因为 `prevent_destroy` 失败。实验清理使用：

```sh
terraform state rm local_file.critical_config
rm -f output/critical-config.txt
```