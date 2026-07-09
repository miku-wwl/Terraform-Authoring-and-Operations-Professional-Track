# Lab 76 backend foundation examples

这里放一个独立的小 Terraform 项目，用来理解 S3 backend + S3 lockfile 背后的基础设施从哪里来。

它不要和 `work/76/main.tf` 放在一起运行：

- `s3-with-lockfile/`：创建 S3 state bucket。`use_lockfile = true` 的锁文件也存放在这个 S3 bucket 里。

真实项目里通常会先用一个单独的 bootstrap/foundation 项目创建这些资源，然后业务项目再通过 `backend.hcl` 使用它们。

注意：本目录示例面向 LocalStack，使用测试凭证和本地 endpoint，不要用于真实 AWS。
