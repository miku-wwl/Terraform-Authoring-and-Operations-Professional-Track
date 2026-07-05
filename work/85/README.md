# 第 85 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `modules/` 下的教学模块实现。

本 lab 参考视频中的 Terraform Registry / AWS EC2 module 演示，但为了避免真实 AWS 费用，本环境使用本地 child module 模拟 EC2 instance 配置蓝图。你练的是 module 调用方式、输入参数传递、输出读取和模块抽象边界。

## 本地执行

```powershell
cd work/85
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
