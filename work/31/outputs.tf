output "lab_instance_ids" {
  description = "LocalStack 中由 bootstrap 创建的 EC2 实例 ID"
  value       = data.aws_instances.lab.ids
}

output "lab_instance_count" {
  description = "匹配到的实验实例数量"
  value       = length(data.aws_instances.lab.ids)
}
