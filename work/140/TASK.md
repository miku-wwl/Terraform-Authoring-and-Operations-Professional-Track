# 第 140 节任务：Auto Scaling Group 与 Launch Template

## 背景

本题来自第 140 节课程内容，目标是把 `Auto Scaling Group 与 Launch Template` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 要求

- 创建 launch template。
- 建模使用 launch template 的 Auto Scaling Group 关键配置。
- 理解 LocalStack Community 不支持真实创建 ASG，本实验只验证 Launch Template 与 ASG 配置模型。

## 验收

完成后执行：

```powershell
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/140/`。
