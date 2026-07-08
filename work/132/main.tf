# Lab 132 知识点总结：
# - data "aws_caller_identity" 用来读取当前 provider 凭证对应的调用者身份。
# - 它不创建任何资源，只通过 STS 查询 account_id、user_id、arn 等身份信息。
# - 真实 AWS 中这些值代表真实账号/角色/用户；本实验中它们来自 LocalStack 模拟身份。
# - 这些输出常用于拼接 ARN、校验当前账号、避免把 account id 写死在配置中。

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user_id" {
  value = data.aws_caller_identity.current.user_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}
