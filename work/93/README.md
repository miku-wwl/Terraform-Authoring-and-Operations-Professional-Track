# 第 93 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改其他目录下的参考资料或讲义文件。

本 lab 聚焦 Terraform module 中的变量设计：不要把模块内部的资源参数写死，而是把调用方需要覆盖的配置抽象成 `variable`，再在模块实现里通过 `var.<name>` 引用。

## 本地执行

```powershell
cd work/93
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
