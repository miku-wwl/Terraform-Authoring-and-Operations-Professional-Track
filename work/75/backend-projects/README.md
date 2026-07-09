# Lab 75 backend foundation examples

这里放一个独立的小 Terraform 项目，用来理解 S3 backend + DynamoDB state locking 背后的基础设施从哪里来。

它不要和 `work/75/main.tf` 放在一起运行：

- `s3-with-dynamodb-lock/`：创建 S3 state bucket，并额外创建 DynamoDB lock table。

真实项目里通常会先用一个单独的 bootstrap/foundation 项目创建这些资源，然后业务项目再通过 `backend.hcl` 使用它们。

注意：本目录示例面向 LocalStack，使用测试凭证和本地 endpoint，不要用于真实 AWS。
