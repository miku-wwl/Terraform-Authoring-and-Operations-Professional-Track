# Lab 77 backend foundation examples

这里放一个独立的小 Terraform 项目，用来理解 Lab77 远端 state 查看练习背后的 S3 bucket 从哪里来。

它不要和 `work/77/main.tf` 放在一起运行：

- `s3-for-state-audit/`：创建保存 Terraform state 的 S3 bucket。

Lab77 的重点不是创建更多 backend 组件，而是 state 已经进入 S3 backend 后，使用 Terraform CLI 查看它：

- `terraform state list`
- `terraform state show terraform_data.state_audit`
- `terraform state pull`

注意：本目录示例面向 LocalStack，使用测试凭证和本地 endpoint，不要用于真实 AWS。
