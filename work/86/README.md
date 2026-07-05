# 第 86 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/` 下的参考实现或讲义文件。

## 本地执行

```powershell
cd work/86
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

## 注意

本 lab 不会真正下载 AWS community module，也不会创建 AWS 资源。这里用本地 JSON mock 数据模拟 module 文档中的关键信息，重点训练你在引用 module 前做输入检查和结构判断。
