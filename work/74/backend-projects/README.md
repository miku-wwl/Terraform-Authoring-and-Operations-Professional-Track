# Lab 74 backend foundation examples

这里放一个独立的小 Terraform 项目，用来理解 S3 remote backend 背后的 bucket 从哪里来。

它不要和 `work/74/main.tf` 放在一起运行：

- `s3-only/`：创建只用于保存 Terraform state 的 S3 bucket。

真实项目里通常会先用一个单独的 bootstrap/foundation 项目创建这些资源，然后业务项目再通过 `backend.hcl` 使用它们。

注意：本目录示例面向 LocalStack，使用测试凭证和本地 endpoint，不要用于真实 AWS。

S3 + DynamoDB state locking 的 foundation 示例放在 `work/75/backend-projects/`，对应 Lab75。
