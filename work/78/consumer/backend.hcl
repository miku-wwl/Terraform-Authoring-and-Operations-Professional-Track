# Lab 78 consumer/backend.hcl
# 这个文件配置的是“下游 consumer 项目自己的 state 存到哪里”。
# 执行 init 时需要在 consumer 目录里显式传入：
# terraform init -backend-config=backend.hcl

# bucket：consumer 项目的 Terraform state 要存放到哪个 S3 bucket。
# 注意：这个 bucket 可以和 network 共用，但 key 必须不同，避免覆盖上游 state。
bucket = "tf-pro-state-localstack"

# key：consumer 项目的 state 文件在 bucket 里的路径。
# 这是下游自己的 state，不是它要读取的 network state。
key = "labs/78/consumer/terraform.tfstate"

# region：S3 backend 使用的 AWS region。
# LocalStack lab 统一使用 us-east-1。
region = "us-east-1"

# access_key / secret_key：LocalStack 测试凭证。
# 注意：这里只能用于本地 LocalStack，不要把真实 AWS key 写进文件。
access_key = "test"
secret_key = "test"

# 重点区别：
# - consumer/backend.hcl 决定 consumer 自己的 state 放哪里。
# - consumer/main.tf 里的 data "terraform_remote_state" 才决定去哪里读取 network outputs。
# 所以不要把这两个概念混在一起。

# Lab78 的重点是 terraform_remote_state 读取 outputs，不是 state locking。
# 所以这里不启用 dynamodb_table，也不启用 use_lockfile。

# 下面这些 skip_* 是为了让 Terraform 不去做真实 AWS 的身份、region、账号校验。
# 连接 LocalStack 时通常需要打开。
# 真实 AWS 项目里通常不写这些字段，也不需要显式写 false。
skip_credentials_validation = true
skip_metadata_api_check     = true
skip_region_validation      = true
skip_requesting_account_id  = true

# LocalStack 的 S3 endpoint 通常需要 path-style 地址。
use_path_style = true

# endpoints：把 Terraform backend 的 AWS API 请求指向本机 LocalStack。
# 如果是真实 AWS backend，这一段通常不需要写。
# consumer apply 后，你可以用下面命令查看下游 state：
# aws --endpoint-url=http://localhost:4566 s3 cp s3://tf-pro-state-localstack/labs/78/consumer/terraform.tfstate -
endpoints = {
  s3       = "http://localhost:4566"
  dynamodb = "http://localhost:4566"
}
