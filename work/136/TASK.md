# 第 136 节任务：aws_iam_policy_document 策略文档数据源

## 背景

本题来自第 136 节课程内容，目标是把 `aws_iam_policy_document 策略文档数据源` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 知识点总结

- `aws_iam_policy_document` 用 HCL 生成 IAM JSON 策略。
- `.json` 属性是生成后的 JSON 字符串。
- 生成结果可以直接传给 `aws_iam_policy.policy`。

## 要求

- 使用 aws_iam_policy_document 生成 JSON 策略。
- 通过 statement、actions、resources 表达权限。
- 把生成的 JSON 用于 IAM policy。

## Hint

完整示例见 `main.tf` 中的注释答案；核心引用如下：

```hcl
policy = data.aws_iam_policy_document.read_logs.json
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
- 不要修改 `practice/labs/136/`。
