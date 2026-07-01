# 第 156 节参考实现：挑战一解法三：S3 object 与状态清理

这个目录是参考答案目录，用于验证题目设计是否可运行。学习或上机时请使用 `work/156/`。

## 本地验证流程

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\practice\labs\156
powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
```

理论型 lab 不需要执行 Terraform，只运行 bootstrap、verify、clean 三个脚本。
