# Lab 132 知识点总结：
# - data block 查询 provider 暴露的外部信息，不创建或管理 AWS resource。
# - aws_caller_identity 通过 STS GetCallerIdentity 查询 AWS Provider 当前实际使用的身份。
# - 该 data source 不需要参数，常用属性是 account_id、user_id、arn；id 与 account_id 相同。
# - user_id 是 calling entity 的唯一标识，不等于 IAM 用户名。
# - arn 是 calling entity 的 ARN，可能属于 IAM User、Assumed Role session 或其他 principal。
# - account_id 常用于动态拼接 IAM ARN 或 policy，避免把十二位 AWS Account ID 写死在配置里。
# - 本实验只连接 LocalStack STS；默认模拟 Account ID 是 000000000000。
# - LocalStack 可以验证 Provider、STS、data source、引用和 output 链路，但不能证明真实 AWS IAM 授权正确。
#
# 请依次完成 TODO 1～3。每个 TODO 都提供可以直接使用的完整答案级 Hint。

# TODO 1：声明 aws_caller_identity data source，读取当前 AWS Provider 身份。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# data "aws_caller_identity" "current" {}

locals {
  # TODO 2：把 data source 返回的三个关键属性放入 caller_identity。
  # 答案级 Hint：用下面的完整对象替换当前占位对象：
  # caller_identity = {
  #   account_id = data.aws_caller_identity.current.account_id
  #   user_id    = data.aws_caller_identity.current.user_id
  #   arn        = data.aws_caller_identity.current.arn
  # }
  caller_identity = {
    account_id = ""
    user_id    = ""
    arn        = ""
  }

  # TODO 3：使用动态 account_id 拼接 Role ARN，并判断当前身份是否来自本实验 LocalStack。
  # 答案级 Hint：完整答案如下：
  # example_role_arn = "arn:aws:iam::${local.caller_identity.account_id}:role/platform-deployer"
  # is_localstack    = local.caller_identity.account_id == "000000000000"
  example_role_arn = ""
  is_localstack    = false
}

output "account_id" {
  description = "Account ID that owns or contains the current calling entity."
  value       = local.caller_identity.account_id
}

output "caller_user_id" {
  description = "Unique identifier of the current calling entity; this is not necessarily an IAM username."
  value       = local.caller_identity.user_id
}

output "caller_arn" {
  description = "ARN of the current calling entity."
  value       = local.caller_identity.arn
}

output "example_role_arn" {
  description = "Example IAM role ARN built without hard-coding the AWS account ID."
  value       = local.example_role_arn
}

output "is_localstack" {
  description = "Whether the caller account matches this lab's default LocalStack account."
  value       = local.is_localstack
}
