# 第 135 节任务：IAM Policy 与用户绑定

## 背景

本题来自第 135 节课程内容，目标是把 `IAM Policy 与用户绑定` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 知识点总结

- `jsonencode` 可以把 HCL object/list 转成 IAM policy 需要的 JSON 字符串。
- `aws_iam_policy` 创建托管策略。
- `aws_iam_user_policy_attachment` 把策略绑定到 IAM user。

## 要求

- 用 jsonencode 编写 IAM policy。
- 把策略绑定到指定 IAM user。
- 用输出确认用户和策略 ARN。

## Hint

完整示例见 `main.tf` 中的注释答案；关键绑定如下：

```hcl
resource "aws_iam_user_policy_attachment" "reader" {
  user       = aws_iam_user.reader.name
  policy_arn = aws_iam_policy.s3_read.arn
}
```

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
