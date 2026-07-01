# Lab 33 任务：单实例与多实例 Data Source

## 背景

`scripts/bootstrap.sh` 会创建两台模拟 EC2：一台 `Team=production`，一台 `Team=development`。

## 任务目标

你需要同时使用：

- `aws_instance`：精确读取一台生产实例
- `aws_instances`：读取全部 lab 实例

## 你需要编辑的文件

- `main.tf`
- `outputs.tf`

## 禁止事项

- 不要创建新的 `aws_instance` resource。
- 不要把实例 ID 写死。
- 不要访问真实 AWS。

## 验收标准

- `production_instance_id` 有值。
- `all_lab_instance_count` 至少为 2。
- `bash scripts/verify.sh` 通过。
