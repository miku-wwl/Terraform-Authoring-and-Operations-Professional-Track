# 第 142 节任务：AWS CLI source_profile 配置

## 背景

本题来自第 142 节课程内容，目标是把 `AWS CLI source_profile 配置` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 要求

- 创建 AWS CLI base profile。
- 创建通过 source_profile 继承凭证的 lab profile。
- 理解 source_profile 与 assume role 配置的关系。

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
- 不要修改 `practice/labs/142/`。
