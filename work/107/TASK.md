# 第 107 节任务

## 背景

AWS Provider 指定 shared config/credentials 路径

## 要求

1. 在实验目录创建非默认位置的 AWS config/credentials。
2. 在 provider 中使用 shared_config_files/shared_credentials_files。
3. 创建一个 S3 bucket 验证 provider 能读取这些文件。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/107/`。
