# These outputs are provided so you can focus on the data sources in main.tf.

output "account_id" {
  description = "LocalStack simulated account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  description = "Current caller ARN"
  value       = data.aws_caller_identity.current.arn
}

output "current_region" {
  description = "Current provider region"
  value       = data.aws_region.current.name
}
