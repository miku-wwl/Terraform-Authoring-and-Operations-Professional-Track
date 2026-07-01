# Lab 35 任务：使用动态 AMI 创建 EC2

## 背景

本题延续 Lab 34。你需要先用 `aws_ami` 查询最新模拟 AMI，再把它传给 `aws_instance`。

## 任务目标

创建一台名为 `tf-lab-35-instance` 的 LocalStack EC2，AMI 不能硬编码。

## 你需要编辑的文件

- `main.tf`
- `outputs.tf`

## 禁止事项

- 不要硬编码 AMI ID。
- 不要访问真实 AWS。
- 不要创建 RDS、NAT Gateway、EIP 或其他无关资源。

## 验收标准

- `selected_ami_id` 有值。
- `instance_id` 有值。
- `bash scripts/verify.sh` 通过。
