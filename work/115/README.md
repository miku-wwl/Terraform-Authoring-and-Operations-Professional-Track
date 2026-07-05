# 第 115 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/` 下的参考实现或讲义文件。

## 本地执行

```powershell
cd work/115
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

## 观察 Terraform debug log

完成 TODO 后，可以额外用下面的方式观察日志输出。

PowerShell：

```powershell
$env:TF_LOG="TRACE"
$env:TF_LOG_PATH="terraform-debug.log"
terraform plan -input=false -no-color
Remove-Item Env:TF_LOG
Remove-Item Env:TF_LOG_PATH
```

Bash：

```bash
TF_LOG=TRACE TF_LOG_PATH=terraform-debug.log terraform plan -input=false -no-color
```

最终验证时会使用 `terraform fmt -check`。
