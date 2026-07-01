# 第 113 节任务

## 背景

AWS Provider Assume Role 实操

## 要求

1. 在 provider 中配置 assume_role。
2. 使用 LocalStack STS endpoint。
3. 创建 S3 bucket 验证 provider 已完成 assume role 调用路径。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/113/`。
