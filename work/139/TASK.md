# 第 139 节任务：Launch Template 基础配置

## 背景

本题来自第 139 节课程内容，目标是把 `Launch Template 基础配置` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 要求

- 创建 launch template。
- 配置 AMI、实例类型和标签规格。
- 输出 launch template id。

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
- 不要修改 `practice/labs/139/`。
