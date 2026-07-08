# 第 142 节任务：AWS CLI source_profile 配置

## 背景

本题来自第 142 节课程内容，目标是把 `AWS CLI source_profile 配置` 转换成可运行、可验证、可清理的 CLI 配置练习。

## 知识点总结

- AWS CLI profile 可以写在 `config` 和 `credentials` 两类文件里。
- base profile 保存基础凭证；lab profile 可以通过 `source_profile = base` 复用它。
- 配合 `role_arn` 时，AWS CLI 会先读取 source profile 的凭证，再尝试 assume role。
- `source_profile` 只是指定凭证来源，不等于授权；能否 assume role 还取决于 IAM trust policy 和权限。

## 要求

- 创建 AWS CLI base profile。
- 创建通过 source_profile 继承凭证的 lab profile。
- 理解 source_profile 与 assume role 配置的关系。

## Hint

本 lab 的脚本会在 `aws-config/` 下生成配置文件。核心答案如下：

```ini
[profile base]
region = us-east-1
output = json

[profile lab-142]
region = us-east-1
source_profile = base
role_arn = arn:aws:iam::000000000000:role/tf-pro-lab-142-demo
```

credentials 文件里只需要 base profile 的基础凭证：

```ini
[base]
aws_access_key_id = test
aws_secret_access_key = test
```

## 验收

完成后执行：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/142/`。
