# Lab 77 backend.hcl
# 这个文件不会被 Terraform 自动加载。
# 执行 init 时需要显式传入：
# terraform init -backend-config=backend.hcl

# bucket：Terraform state 要存放到哪个 S3 bucket。
# 本 lab 的 scripts/bootstrap.ps1 会在 LocalStack 里创建这个 bucket。
bucket = "tf-pro-state-localstack"

# key：state 文件在 bucket 里的路径。
# Lab77 会通过 terraform state list/show/pull 从这个远端 state 读取内容。
key = "labs/77/terraform.tfstate"

# region：S3 backend 使用的 AWS region。
# LocalStack lab 统一使用 us-east-1。
region = "us-east-1"

# access_key / secret_key：LocalStack 测试凭证。
# 注意：这里只能用于本地 LocalStack，不要把真实 AWS key 写进文件。
access_key = "test"
secret_key = "test"

# Lab77 的主题是查看远端 state，不是 state locking。
# 所以这里不启用 dynamodb_table，也不启用 use_lockfile。
# 本节要练的是：
# terraform state list
# terraform state show terraform_data.state_audit
# terraform state pull
#
# terraform state list：
# 列出当前 backend 的 state 里有哪些资源地址。
# 常用于确认“这个资源是不是已经被当前 Terraform 项目管理”。
#
# terraform state show terraform_data.state_audit：
# 查看某一个资源在 state 里保存的详细属性。
# 常用于排查 plan 差异，或者确认资源 ID、input、output 等 state 内容。
#
# terraform state pull：
# 从当前 backend 拉取完整 state JSON，并打印到终端。
# 它不是查看某一个资源，而是查看整份 state 文件；适合只读审计。
# 不要手工编辑 pull 出来的 JSON 再随便 push 回去。

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
# Lab77 只使用 S3 backend；dynamodb endpoint 只是为了和 example/脚本环境保持兼容。
# 如果是真实 AWS backend，这一段通常不需要写。
# 查看远端 state 的常用命令：
# terraform state list
# terraform state show terraform_data.state_audit
# terraform state pull
# aws --endpoint-url=http://localhost:4566 s3 cp s3://tf-pro-state-localstack/labs/77/terraform.tfstate -
endpoints = {
  s3       = "http://localhost:4566"
  dynamodb = "http://localhost:4566"
}
