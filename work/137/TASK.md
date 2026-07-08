# 第 137 节任务：IAM Role 与 AssumeRole 信任策略

## 背景

本题来自第 137 节课程内容，目标是把 `IAM Role 与 AssumeRole 信任策略` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 知识点总结

- IAM role 的 trust policy 决定“谁可以 assume 这个 role”。
- EC2 要扮演 role 时，可信主体写成 Service principal：`ec2.amazonaws.com`。
- `assume_role_policy` 是信任策略，不是权限策略。

## 要求

- 用 aws_iam_policy_document 编写 role trust policy。
- 创建允许 EC2 assume role 的 IAM role。
- 输出 role ARN 并理解信任策略的作用。

## Hint

完整示例见 `main.tf` 中的注释答案；关键结构如下：

```hcl
principals {
  type        = "Service"
  identifiers = ["ec2.amazonaws.com"]
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
- 不要修改 `practice/labs/137/`。
