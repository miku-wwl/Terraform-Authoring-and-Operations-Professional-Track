# 第 134 节任务：IAM 用户、登录配置与访问密钥

## 背景

本题来自第 134 节课程内容，目标是把 `IAM 用户、登录配置与访问密钥` 转换成可运行、可验证、可销毁的 Terraform 练习。

## 要求

- 创建 IAM user。
- 为用户创建 login profile 和 access key。
- 把敏感输出标记为 sensitive，避免明文泄露。

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
- 不要修改 `practice/labs/134/`。
