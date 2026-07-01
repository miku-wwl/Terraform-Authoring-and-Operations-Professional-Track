# Lab 34 任务：避免硬编码 AMI

## 背景

AMI ID 在真实 AWS 中是 region-specific 的。`scripts/bootstrap.sh` 会在 LocalStack 中注册两个模拟 AMI，用于训练 `aws_ami` 查询写法。

## 任务目标

使用 `data "aws_ami"` 按名称筛选最新模拟 AMI。

## 你需要编辑的文件

- `main.tf`
- `outputs.tf`

## 禁止事项

- 不要硬编码某个 AMI ID。
- 不要访问真实 AWS 公共 AMI。
- 不要把 LocalStack 结果说成等价于真实 AWS AMI 目录。

## 验收标准

- `latest_ami_id` 有值。
- `latest_ami_name` 以 `tf-lab-ubuntu-` 开头。
- `bash scripts/verify.sh` 通过。
