# Lab 76 backend.hcl
# 这个文件不会被 Terraform 自动加载。
# 执行 init 时需要显式传入：
# terraform init -backend-config=backend.hcl

# bucket：Terraform state 要存放到哪个 S3 bucket。
# 本 lab 的 scripts/bootstrap.ps1 会在 LocalStack 里创建这个 bucket。
bucket = "tf-pro-state-localstack"

# key：state 文件在 bucket 里的路径。
# 你可以把它理解成 S3 里的“文件名/目录名”。
key = "labs/76/terraform.tfstate"

# region：S3 backend 使用的 AWS region。
# LocalStack lab 统一使用 us-east-1。
region = "us-east-1"

# access_key / secret_key：LocalStack 测试凭证。
# 注意：这里只能用于本地 LocalStack，不要把真实 AWS key 写进文件。
access_key = "test"
secret_key = "test"

# use_lockfile：新式 S3 backend locking。
# Terraform 会在同一个 S3 bucket/key 附近创建锁文件来协调并发操作。
# 注意：不是 S3 bucket 资源本身多了某个 state-lock 开关。
# Lab74 和 Lab76 提前创建的 S3 bucket 可以完全一样；差异在这里的 backend 配置。
# 和 Lab75 的 dynamodb_table 不同，这种方式不需要 DynamoDB table。
# 新项目优先学习这个写法；旧项目里才常见 dynamodb_table。
use_lockfile = true

# 下面这些 skip_* 是为了让 Terraform 不去做真实 AWS 的身份、region、账号校验。
# 连接 LocalStack 时通常需要打开。
# 真实 AWS 项目里通常不写这些字段，也不需要显式写 false。
skip_credentials_validation = true
skip_metadata_api_check     = true
skip_region_validation      = true
skip_requesting_account_id  = true

# LocalStack 的 S3 endpoint 通常需要 path-style 地址。
use_path_style = true

# endpoints：把 Terraform backend 的 S3 API 请求指向本机 LocalStack。
# Lab76 不使用 DynamoDB，所以这里不需要配置 dynamodb endpoint。
# 如果是真实 AWS backend，这一段通常不需要写。
# LocalStack Community 本地容器没有内置 AWS Console 式网页界面。
# 查看 S3 里的远端 state，通常用 AWS CLI 或支持 S3 endpoint 的客户端。
# 常用命令：
# aws --endpoint-url=http://localhost:4566 s3 ls s3://tf-pro-state-localstack --recursive
# aws --endpoint-url=http://localhost:4566 s3 cp s3://tf-pro-state-localstack/labs/76/terraform.tfstate -
endpoints = {
  s3 = "http://localhost:4566"
}
