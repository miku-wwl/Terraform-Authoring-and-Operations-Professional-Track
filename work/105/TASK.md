# 第 105 节任务

## 背景

把根配置拆分为子模块

## 要求

1. 把 IAM 与 S3 资源拆入不同 child module。
2. 在 root module 写 moved block。
3. 验证迁移后 state 地址进入 module。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/105/`。
