# 第 135 节任务：IAM Policy 与用户绑定

## 背景

本题来自第 135 节课程内容，目标是把 `IAM Policy 与用户绑定` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 要求

- 用 jsonencode 编写 IAM policy。
- 把策略绑定到指定 IAM user。
- 用输出确认用户和策略 ARN。

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
- 不要修改 `practice/labs/135/`。
