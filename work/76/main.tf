terraform {
  required_version = ">= 1.12.0"
}

# Lab 76 知识点总结：
# - Lab 75 使用旧式 DynamoDB state locking；Lab 76 使用新式 S3 lockfile。
# - S3 backend 仍然负责保存 state，use_lockfile = true 让 Terraform 在 S3 中创建锁文件来协调并发操作。
# - 新式 lockfile 不需要 DynamoDB table，backend.hcl.example 中也不应配置 dynamodb_table。
# - key = "labs/76/terraform.tfstate" 决定 state 文件在 S3 bucket 里的对象路径。
# - endpoints 只需要配置 s3，因为本实验不再使用 DynamoDB。
# - terraform_data 是 Terraform 内置资源，适合在实验中创建一个轻量对象来证明 state 和 locking 流程可用。

resource "terraform_data" "s3_lockfile_marker" {
  input = {
    lab         = "76"
    lock_method = "use_lockfile"
  }
}
