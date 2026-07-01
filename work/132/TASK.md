# 第 132 节任务：aws_caller_identity 数据源

## 背景

本题来自第 132 节课程内容，目标是把 `aws_caller_identity 数据源` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 要求

- 使用 data "aws_caller_identity" "current" 读取当前调用者信息。
- 输出 account_id、user_id 和 arn。
- 说明 LocalStack 中 STS 身份与真实 AWS 身份的差异。

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
- 不要修改 `practice/labs/132/`。
