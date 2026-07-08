output "latest_ami_id" {
  description = "通过 aws_ami 查询到的最新模拟 AMI ID"
  value       = data.aws_ami.latest.id
}

output "latest_ami_name" {
  description = "通过 aws_ami 查询到的最新模拟 AMI 名称"
  value       = data.aws_ami.latest.name
}
