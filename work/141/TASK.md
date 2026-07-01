# 第 141 节任务：S3 Bucket Policy

## 背景

本题来自第 141 节课程内容，目标是把 `S3 Bucket Policy` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 要求

- 创建 S3 bucket。
- 用 aws_iam_policy_document 生成 bucket policy。
- 将策略绑定到 bucket。

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
- 不要修改 `practice/labs/141/`。
