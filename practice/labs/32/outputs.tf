output "account_id" {
  description = "LocalStack 模拟账号 ID"
  value       = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  description = "当前调用者 ARN"
  value       = data.aws_caller_identity.current.arn
}

output "current_region" {
  description = "当前 provider region"
  value       = data.aws_region.current.name
}
