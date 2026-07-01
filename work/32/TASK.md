# Lab 32 任务：区分 Resource 与 Data Source

## 背景

你需要确认 Terraform 当前连接的是 LocalStack 模拟账号，而不是你的真实 AWS 账号。

## 任务目标

使用 AWS provider 的只读 data source 输出当前账号 ID、调用者 ARN 和 region。

## 你需要编辑的文件

- `main.tf`
- `outputs.tf`

## 禁止事项

- 不要创建任何 AWS resource。
- 不要配置真实 access key。
- 不要删除 provider 中的 LocalStack endpoint。

## 验收标准

- `account_id` 输出为 `000000000000`。
- `caller_arn` 和 `current_region` 有值。
- `bash scripts/verify.sh` 通过。
