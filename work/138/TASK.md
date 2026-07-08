# 第 138 节任务：IAM Role Policy Attachment

## 背景

本题来自第 138 节课程内容，目标是把 `IAM Role Policy Attachment` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 知识点总结

- IAM role 的 trust policy 决定谁可以 assume role。
- IAM policy 决定 role 被使用后拥有哪些权限。
- `aws_iam_role_policy_attachment` 把 managed policy 绑定到 role 上。

## 要求

- 创建 IAM role。
- 创建 IAM policy。
- 使用 aws_iam_role_policy_attachment 完成绑定。

## Hint

完整示例见 `main.tf` 中的注释答案；绑定关系核心如下：

```hcl
resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.logs.arn
}
```

## 验收

完成后执行：

```powershell
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/138/`。
